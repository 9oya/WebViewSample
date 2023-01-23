//
//  WebViewWrapper.swift
//  WebViewSample
//
//  Created by 9oya on 2023/01/23.
//

import SwiftUI
import WebKit

struct WebViewWrapper: View {
    @Environment(\.dismiss) var dismiss
    var webView: WebView
    
    init(webView: WebView) {
        self.webView = webView
    }
    
    var body: some View {
        VStack {
            webView
            
            HStack {
                Button(action: {
                    self.webView.goBack()
                }){
                    Image(systemName: "arrowtriangle.left.fill")
                        .font(.title)
                        .foregroundColor(.blue)
                        .padding()
                }
                Spacer()
                Button(action: {
                    dismiss()
                }){
                    Image(systemName: "house.fill")
                        .font(.title)
                        .foregroundColor(.blue)
                        .padding()
                }
                Spacer()
                Button(action: {
                    self.webView.refresh()
                }){
                    Image(systemName: "arrow.clockwise.circle.fill")
                        .font(.title)
                        .foregroundColor(.blue)
                        .padding()
                }
                Spacer()
                Button(action: {
                    self.webView.goForward()
                }){
                    Image(systemName: "arrowtriangle.right.fill")
                        .font(.title)
                        .foregroundColor(.blue)
                        .padding()
                }
            }
        }
    }
}

struct WebView: UIViewRepresentable {
    var urlRequest: URLRequest
    private var webView: WKWebView?
    
    init(urlRequest: URLRequest) {
        self.urlRequest = urlRequest
        self.webView = WKWebView()
    }
    
    func makeUIView(context: Context) -> WKWebView {
        return webView!
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(urlRequest)
    }
    
    func goBack(){
        webView?.goBack()
    }
    
    func goForward(){
        webView?.goForward()
    }
    
    func refresh() {
        webView?.reload()
    }
}
