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
//  File    : LandingFinishScreen.swift
//

import SwiftUI

struct LandingFinishScreen: View {
    @ObservedObject var windowManager = HitoriWindowManager.shared
    @EnvironmentObject var window: HitoriWindow

    var body: some View {
        NavigationStack {
            Spacer()
            Text("Your Workspace is Ready!")
                .font(.largeTitle)
            Text("Let's get started")
                .font(.title2)
            Spacer()
            HStack {
                Button("Finish") {
                    windowManager.newWindow()
                    window.close()
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
}
