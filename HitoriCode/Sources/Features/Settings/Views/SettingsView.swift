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
    @ObservedObject var config = HitoriConfig.shared

    var body: some View {
        BackgroundView {
            VStack {
                Button("Set System") {
                    config.theme = .system
                }
                Button("Set Dark") {
                    config.theme = .dark
                }
                Button("Set Light") {
                    config.theme = .light
                }
                Button("Set Hitori") {
                    config.theme = .hitori
                }
                Button("Set Nijika") {
                    config.theme = .nijika
                }
                Button("Set Ryo") {
                    config.theme = .ryo
                }
                Button("Set Kita") {
                    config.theme = .kita
                }
            }
        }
    }
}
