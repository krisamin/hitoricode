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
//  Package : HitoriCode
//  File    : HitoriCodeApp.swift
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

struct WindowAccessor: NSViewRepresentable {
    func makeNSView(context _: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async {
            if let window = view.window {
//                window.styleMask.remove(.titled)
//                window.styleMask.insert(.fullSizeContentView)
//                window.titlebarAppearsTransparent = true
//                window.titleVisibility = .hidden
//                window.isMovableByWindowBackground = true

                window.standardWindowButton(.closeButton)?.isHidden = true
                window.standardWindowButton(.miniaturizeButton)?.isHidden = true
                window.standardWindowButton(.zoomButton)?.isHidden = true

//                if let contentView = window.contentView {
//                    contentView.wantsLayer = true
//                    contentView.layer?.cornerRadius = 10
//                    contentView.layer?.masksToBounds = true
//                }
            }
        }
        return view
    }

    func updateNSView(_: NSView, context _: Context) {}
}

@main
struct HitoriCodeApp: App {
    var body: some Scene {
        WindowGroup(id: "landing") {
            LandingView()
                .frame(width: 400, height: 400)
                .containerBackground(for: .window) {
                    WindowAccessor()
                    VisualEffectView()
                    Color.white.opacity(0.4)
                }
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
        .defaultPosition(.center)
//        .commandsRemoved()

        WindowGroup(id: "welcome") {
            WelcomeView()
                .frame(width: 800, height: 400)
                .containerBackground(for: .window) {
                    WindowAccessor()
                    VisualEffectView()
                    Color.white.opacity(0.4)
                }
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
        .defaultPosition(.center)
//        .commandsRemoved()

        WindowGroup(id: "workspace") {
            WorkspaceView()
                .frame(
                    minWidth: 400,
                    maxWidth: .infinity,
                    minHeight: 300,
                    maxHeight: .infinity
                )
                .containerBackground(for: .window) {
                    VisualEffectView()
                    Color.white.opacity(0.4)
                }
        }
        .windowStyle(.hiddenTitleBar)
        .defaultPosition(.center)
        .defaultSize(width: 1200, height: 800)
//        .commandsRemoved()
    }
}
