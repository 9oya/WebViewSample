//
//  WebViewWrapper.swift
//  WebViewSample
//
//  Created by 9oya on 2023/01/23.
//

import SwiftUI
import WebKit
import UIKit

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
        webView?.uiDelegate = context.coordinator
        webView?.navigationDelegate = context.coordinator as WKNavigationDelegate
        webView?.allowsBackForwardNavigationGestures = true
        webView?.scrollView.isScrollEnabled = true
        
        return webView!
    }
    
    func makeCoordinator() -> WebViewCoordinator {
        return WebViewCoordinator(self)
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

// MARK: WKUIDelegate
class WebViewCoordinator: NSObject, WKUIDelegate {
    var parent: WebView
    
    init(_ parent: WebView) {
        self.parent = parent
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alertController = UIAlertController(title: message, message: nil, preferredStyle: .alert);
        
        let cancelAction = UIAlertAction(title: "확인", style: .cancel) {
            _ in completionHandler()
        }
        
        alertController.addAction(cancelAction)
        DispatchQueue.main.async {
            UIApplication
                .shared
                .topViewController()?
                .present(alertController, animated: true)
        }
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
}

// MARK: WKNavigationDelegate
extension WebViewCoordinator: WKNavigationDelegate {
    
}
