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
//  Created : 10/9/24
//  Package : HitoriCode
//  File    : HitoriWindow.swift
//

import SwiftUI

class HitoriWindowStyle {
    let contentRect: NSRect
    let styleMask: NSWindow.StyleMask

    init(contentRect: NSRect, styleMask: NSWindow.StyleMask) {
        self.contentRect = contentRect
        self.styleMask = styleMask
    }
}

enum HitoriWindowType {
    case landing
    case welcome
    case workspace

    func getWindowStyle() -> HitoriWindowStyle {
        switch self {
        case .landing:
            HitoriWindowStyle(
                contentRect: NSRect(x: 0, y: 0, width: 400, height: 400),
                styleMask: [.fullSizeContentView]
            )
        case .welcome:
            HitoriWindowStyle(
                contentRect: NSRect(x: 0, y: 0, width: 600, height: 400),
                styleMask: [.fullSizeContentView]
            )
        case .workspace:
            HitoriWindowStyle(
                contentRect: NSRect(x: 0, y: 0, width: 1200, height: 800),
                styleMask: [.fullSizeContentView, .titled, .resizable, .closable, .miniaturizable]
            )
        }
    }
}

class HitoriWindow: NSWindow, NSWindowDelegate {
    @ObservedObject var windowManager: HitoriWindowManager
    @ObservedObject var appConfig: HitoriAppConfig

    let windowType: HitoriWindowType

    init(
        _ appConfig: HitoriAppConfig,
        _ windowType: HitoriWindowType,
        _ windowManager: HitoriWindowManager
    ) {
        self.appConfig = appConfig
        self.windowType = windowType
        self.windowManager = windowManager

        let windowStyle = windowType.getWindowStyle()

        super.init(
            contentRect: windowStyle.contentRect,
            styleMask: windowStyle.styleMask,
            backing: .buffered,
            defer: false
        )
        delegate = self

        setupWindowProperties()
        setupWindowContent()
    }

    func windowDidBecomeKey(_: Notification) {
        print("focused \(windowType)")
    }

    func windowDidResignKey(_: Notification) {
        print("unfocused \(windowType)")
    }

    private func setupWindowProperties() {
        isOpaque = false
        backgroundColor = NSColor(calibratedWhite: 0, alpha: 0)
        isMovableByWindowBackground = true
        titlebarAppearsTransparent = true
        title = "HitoriCode"
        appearance = nil // NSAppearance(named: .vibrantDark)
        center()
    }

    private func setupWindowContent() {
        guard let contentView else { return }

        setupContentViewLayer(contentView)
        setupBlurView(contentView)
        setupHostingView(contentView)
    }

    private func setupContentViewLayer(_ contentView: NSView) {
        contentView.wantsLayer = true
        if let layer = contentView.layer {
            layer.cornerRadius = 10
            layer.masksToBounds = true
            layer.backgroundColor = NSColor.clear.cgColor
        }
    }

    private func setupBlurView(_ contentView: NSView) {
        let blurView = NSVisualEffectView()
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.material = .fullScreenUI
        blurView.blendingMode = .behindWindow
        blurView.state = .active
        contentView.addSubview(blurView)

        NSLayoutConstraint.activate([
            blurView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            blurView.topAnchor.constraint(equalTo: contentView.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    private func setupHostingView(_ contentView: NSView) {
        let hostingView = switch windowType {
        case .landing:
            NSHostingView(rootView: LandingView())
        case .welcome:
            NSHostingView(rootView: WelcomeView())
        case .workspace:
            NSHostingView(rootView: WorkspaceView(windowManager: windowManager, appConfig: appConfig, window: self))
        }

        hostingView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(hostingView)

        NSLayoutConstraint.activate([
            hostingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            hostingView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            hostingView.topAnchor.constraint(equalTo: contentView.topAnchor),
            hostingView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
