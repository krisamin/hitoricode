//
//  ██   ██ ██████  ██ ███████  █████  ███    ███ ██ ███    ██
//  ██  ██  ██   ██ ██ ██      ██   ██ ████  ████ ██ ████   ██
//  █████   ██████  ██ ███████ ███████ ██ ████ ██ ██ ██ ██  ██
//  ██  ██  ██   ██ ██      ██ ██   ██ ██  ██  ██ ██ ██  ██ ██
//  ██   ██ ██   ██ ██ ███████ ██   ██ ██      ██ ██ ██   ████
//
//  https://isamin.kr
//  https://github.com/krisamin
//
//  Created : 10/10/24
//  Package : HitoriCode
//  File    : BackgroundView.swift
//

import SwiftUI

struct BackgroundView<Content: View>: View {
    @ObservedObject var config = HitoriConfig.shared
    @ViewBuilder let content: () -> Content

    var body: some View {
        ZStack {
            Color(config.theme.getBackgroundName())
                .ignoresSafeArea()
            content()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.ultraThinMaterial)
    }
}
