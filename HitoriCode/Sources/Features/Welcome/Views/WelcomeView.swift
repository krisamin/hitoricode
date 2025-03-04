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
//  Created : 10/8/24
//  Package : HitoriCode
//  File    : WelcomeView.swift
//

import SwiftUI

struct WelcomeView: View {
    @ObservedObject var windowManager = HitoriWindowManager.shared
    @EnvironmentObject var window: HitoriWindow

    var body: some View {
        BackgroundView {
            VStack {
                Text("Welcome! HitoriCode")
                Button("Open") {
                    windowManager.openWorkspace()
                    window.close()
                }
            }
        }
    }
}
