//
//  APIRouter.swift
//  WebViewSample
//
//  Created by 9oya on 2023/01/30.
//

import Foundation

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "accept"
    case acceptEncoding = "Accept-Encoding"
    case userAgent = "User-Agent"
    case appToken = "App-Token"
}

enum AcceptType: String {
    case anyMIMEgtype = "*/*"
}

enum ContentType: String {
    case accept = "*/*"
    case gzip = "gzip, deflate, br"
    case json = "application/json; charset=utf-8"
    case xwwwFormUrlencoded = "application/x-www-form-urlencoded; charset=utf-8"
}

enum HTTPStatus: Int {
  case ok = 200

  case badRequest = 400
  case notAuthorized = 401
  case paymentRequired = 402
  case forbidden = 403
  case notFound = 404

  case internalServerError = 500
}

enum APIRouter {
    
    // MARK: Base URL
    static let baseURL = "https://accounts.id-im.dev"
    
    // MARK: Cases
    // GET
    case getToken
    
    // MARK: HTTPMethod
    private var method: String {
        switch self {
        case .getToken:
            return "POST"
        }
    }
    
    // MARK: Path
    private var path: String {
        switch self {
        case .getToken:
            return "/auth/realms/healerb/protocol/openid-connect/token"
        }
    }
    
    // MARK: QueryStrings
    private var queryItems: [URLQueryItem]? {
        var queryItems = [URLQueryItem]()
        switch self {
        case .getToken:
            return queryItems
        }
    }
    
    // MARK: HTTPHeader
    private func getAdditionalHttpHeaders() -> [(String, String)] {
        var headers = [(String, String)]()
        switch self {
        case .getToken:
            headers = [(String, String)]()
            return headers
        }
    }
    
    func asURLRequest() -> URLRequest {
        // Base URL
        let url: URL = URL(string: APIRouter.baseURL)!
        
        // Path
        var urlComponents = URLComponents(url: url.appendingPathComponent(path), resolvingAgainstBaseURL: false)
        
        // QueryStrings
        if let queryItems = queryItems {
            urlComponents?.queryItems = queryItems
        }
        
        // URLRequest
        var urlRequest = URLRequest(url: urlComponents!.url!)
        
        // HTTP Method
        urlRequest.httpMethod = method
        
        // Common Headers
        urlRequest.addValue(ContentType.gzip.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptEncoding.rawValue)
        urlRequest.addValue(ContentType.xwwwFormUrlencoded.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        urlRequest.addValue(ContentType.accept.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        
        // Additional Headers
        let headers = getAdditionalHttpHeaders()
        headers.forEach { (header) in
            urlRequest.addValue(header.1, forHTTPHeaderField: header.0)
        }
        
        // Parameters
        urlRequest.httpBody = "".data(using: .utf8)!
        
        return urlRequest
    }
}
