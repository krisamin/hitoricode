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

class HitoriWindow: NSWindow, NSWindowDelegate {
    @ObservedObject var appConfig: HitoriAppConfig

    init(
        _ appConfig: HitoriAppConfig,
        contentRect: NSRect = NSRect(x: 0, y: 0, width: 800, height: 800)
    ) {
        self.appConfig = appConfig
        super.init(
            contentRect: contentRect,
            styleMask: [.fullSizeContentView, .resizable, .titled, .closable, .miniaturizable],
            backing: .buffered,
            defer: false
        )
        delegate = self

        setupWindowProperties()
        setupWindowContent()
    }

    func windowDidBecomeKey(_: Notification) {
        print("focused")
    }

    func windowDidResignKey(_: Notification) {
        print("unfocused")
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
        let hostingView = NSHostingView(rootView: WorkspaceView(appConfig: appConfig))
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
