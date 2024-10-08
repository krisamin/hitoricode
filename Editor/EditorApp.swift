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
//  Created : 10/7/24
//  Package : Editor
//  File    : EditorApp.swift
//

import SwiftUI

struct VisualEffectView: NSViewRepresentable {
    func makeNSView(context _: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.blendingMode = .behindWindow
        view.state = .active
        view.material = .fullScreenUI
        return view
    }

    func updateNSView(_: NSVisualEffectView, context _: Context) {}
}

@main
struct EditorApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .containerBackground(for: .window) {
                    ZStack {
                        VisualEffectView()
                        Color.white.opacity(0.5)
                    }
                }
        }
        .windowStyle(HiddenTitleBarWindowStyle())
        .commandsRemoved()
        .commands {
            CommandMenu("Custom") {
                Button("Item 1") {}
                Divider()
                Button("Item 2") {}
            }
        }
    }
}
