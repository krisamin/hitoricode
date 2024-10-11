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
//  Created : 10/11/24
//  Package : HitoriCode
//  File    : WindowMenu.swift
//

import SwiftUI

struct WindowMenu: View {
    @ObservedObject private var windowManager = HitoriWindowManager.shared

    var body: some View {
        VStack {
            Button("Close") {
                windowManager.currentWindow?.close()
            }.keyboardShortcut("w")
            Button("Minimize") {
                windowManager.currentWindow?.miniaturize(nil)
            }.keyboardShortcut("m")
        }
    }
}

#Preview {
    WindowMenu()
}
