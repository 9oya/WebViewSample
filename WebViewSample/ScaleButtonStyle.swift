//
//  ScaleButtonStyle.swift
//  WebViewSample
//
//  Created by 9oya on 2023/01/24.
//

import SwiftUI

struct ScaleButtonStyle: ButtonStyle {
    init() {}
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.system(size: 22, weight: .bold, design: .default))
            .padding(.horizontal, 100)
            .padding(.vertical, 30)
            .brightness(configuration.isPressed ? -0.05 : 0)
            .foregroundColor(.white)
            .background(Capsule().fill(.blue))
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.linear(duration: 0.2), value: configuration.isPressed)
            
    }
}

extension ButtonStyle where Self == ScaleButtonStyle {
    static var scale: ScaleButtonStyle {
        ScaleButtonStyle()
    }
}
