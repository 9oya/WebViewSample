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
        HTTPCookieStorage.shared.cookieAcceptPolicy = .always
        
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
//        webView?.goForward()
        evaluateJavaScript("localStorage['hb-test-token'] = '${token}'") {
            self.evaluateJavaScript("localStorage['access_token'] = '${token}'") {
                let jsCode = """
                localStorage['order_prodOrderItemReqVO'] = [{"productPageCode":"PDTM00093","productCode":"DGE0000003","optionProductYn":"N","optionProductCode":"","dnaProductYn":"Y","count":1,"type":"P","from":"shop","goodsCode":""}]
                """
                self.evaluateJavaScript(jsCode) {
                    self.webView?.load(urlRequest)
                }
            }
        }
    }
    
    func refresh() {
        webView?.reload()
    }
    
    private func evaluateJavaScript(_ jsCode: String, completed: @escaping ()->Void) {
        webView?.evaluateJavaScript(jsCode, completionHandler: { result, err in
            if let err = err {
                print("evaluate JavaScript infoUpdate Error \(err.localizedDescription)")
            } else {
                completed()
            }
        })
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
    
//    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
//        if navigationAction.targetFrame == nil {
//            webView.load(navigationAction.request)
//        }
//        return nil
//    }
}

// MARK: WKNavigationDelegate
extension WebViewCoordinator: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let response = navigationResponse.response as? HTTPURLResponse,
              let url = navigationResponse.response.url else {
            decisionHandler(.cancel)
            return
        }

        if let headerFields = response.allHeaderFields as? [String: String] {
            let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: url)
            cookies.forEach { cookie in
                webView.configuration.websiteDataStore.httpCookieStore.setCookie(cookie)
            }
        }

        decisionHandler(.allow)
    }
}
