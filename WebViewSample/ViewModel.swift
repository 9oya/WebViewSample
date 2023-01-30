//
//  ViewModel.swift
//  WebViewSample
//
//  Created by 9oya on 2023/01/30.
//

import UIKit
import Combine
import SwiftUI

class ViewModel: ObservableObject {
    var cancellables: [AnyCancellable] = []
    
    // MARK: Inputs
    let fetchToken = PassthroughSubject<String, Never>()
    
    // MARK: Outputs
    @Published var token = ""
    
    init() {
        fetchToken
            .flatMap({ [weak self] _ -> AnyPublisher<String, Error> in
                guard let `self` = self else {
                    return Empty(completeImmediately: true).eraseToAnyPublisher()
                }
                return self.getToken()
            })
            .receive(on: DispatchQueue.main)
            .sink { cmpl in
                guard case .failure(let error) = cmpl else { return }
                print(error.localizedDescription)
            } receiveValue: { token in
                self.token = token
            }
            .store(in: &cancellables)
    }
    
    func dataTask(request: URLRequest,
                  completion: @escaping (Result<Data, Error>)->Void) {
        let task = URLSession(configuration: .default)
            .dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data,
                      let response = response as? HTTPURLResponse {
                print(response.statusCode)
                if response.statusCode == 200 {
                    completion(.success(data))
                } else {
                    let error = NSError(domain: "",
                                        code: response.statusCode,
                                        userInfo: [NSLocalizedDescriptionKey: String(decoding: data, as: UTF8.self)])
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    func getToken() -> AnyPublisher<String, Error> {
        let urlReq = APIRouter.getToken.asURLRequest()
        
        return Future<String, Error>.init { [weak self] promise in
            guard let `self` = self else { return }
            self.dataTask(request: urlReq) { result in
                switch result {
                case .success(let data):
                    do {
                        let model = try JSONDecoder()
                            .decode(TokenModel.self, from: data)
                        promise(.success(model.access_token))
                    } catch let error {
                        promise(.failure(error))
                    }
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
}

struct TokenModel: Codable {
    let access_token: String
}
