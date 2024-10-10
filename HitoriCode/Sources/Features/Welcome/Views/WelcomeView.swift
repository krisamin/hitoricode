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
    @ObservedObject var appConfig: HitoriAppConfig
    @ObservedObject var windowManager: HitoriWindowManager
    var window: HitoriWindow

    var body: some View {
        VStack {
            Text("Welcome! HitoriCode")
            Button("Open") {
                windowManager.openWorkspace()
                window.close()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("Background"))
    }
}
