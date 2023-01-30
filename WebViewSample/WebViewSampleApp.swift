//
//  WebViewSampleApp.swift
//  WebViewSample
//
//  Created by 9oya on 2023/01/22.
//

import SwiftUI

@main
struct WebViewSampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ViewModel())
        }
    }
}
