//
//  ContentView.swift
//  WebViewSample
//
//  Created by 9oya on 2023/01/22.
//

import SwiftUI
import WebKit

struct ContentView: View {
    @State private var isPresented = false
    @State private var hasError = false
    @State private var urlString = "https://www.google.com"
    
    func CustomTextField(_ title: String, text: Binding<String>) -> some View {
        UITextField.appearance().clearButtonMode = .whileEditing
        return TextField(title, text: text)
    }
    
    var body: some View {
        VStack {
            Spacer()
            CustomTextField("Enter your url", text: $urlString)
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .textInputAutocapitalization(.never)
            EmptyView().padding(EdgeInsets(top: 100, leading: 0, bottom: 0, trailing: 0))
            Button("Open Url") {
                if !urlString.isEmpty {
                    if !urlString.contains("http") {
                        urlString = "https://" + urlString
                    }
                    isPresented.toggle()
                } else {
                    hasError.toggle()
                }
            }
            .buttonStyle(ScaleButtonStyle())
            .fullScreenCover(isPresented: $isPresented) {
                WebViewWrapper(webView: WebView(urlRequest: URLRequest(url: URL(string: urlString)!)))
            }
            .alert(isPresented: $hasError) {
                Alert(title: Text("Empty text!"),
                      message: Text("Fill up the url filed"))
            }
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
