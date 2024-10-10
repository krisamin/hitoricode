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
//  File    : SettingsView.swift
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var appConfig = HitoriAppConfig.shared

    var body: some View {
        VStack {
            Button("Set System") {
                appConfig.theme = .system
            }
            Button("Set Dark") {
                appConfig.theme = .dark
            }
            Button("Set Light") {
                appConfig.theme = .light
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("Background"))
    }
}
