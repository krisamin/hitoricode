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
//  File    : LandingView.swift
//

import SwiftUI

struct LandingView: View {
    @ObservedObject var appConfig: HitoriAppConfig
    @ObservedObject var windowManager: HitoriWindowManager
    var window: HitoriWindow

    var body: some View {
        VStack {
            Text("Welcome! this is the landing view.")
            Button("Start") {}
            Button("Finish") {
                windowManager.newWindow()
                window.close()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("Background"))
    }
}
