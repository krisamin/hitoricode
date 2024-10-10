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

import Combine
import SwiftUI

/// 윈도우 클래스
class HitoriWindow: NSWindow, NSWindowDelegate, ObservableObject {
    @ObservedObject var config = HitoriConfig.shared
    @ObservedObject var windowManager = HitoriWindowManager.shared
    let windowType: HitoriWindowType
    let windowStyle: HitoriWindowStyle

    var configThemeSink: AnyCancellable?

    init(
        _ windowType: HitoriWindowType
    ) {
        print("[HitoriWindow] init - \(windowType)")

        self.windowType = windowType
        windowStyle = windowType.getWindowStyle()
        super.init(
            contentRect: windowStyle.contentRect,
            styleMask: windowStyle.styleMask,
            backing: .buffered,
            defer: false
        )
        delegate = self

        setupWindowProperties()
        setupWindowContent()

        configThemeSink = config.$theme.sink { self.setTheme($0) }
    }

    deinit {
        print("[HitoriWindow] deinit - \(windowType)")
    }

    override var canBecomeKey: Bool {
        true
    }

    override var canBecomeMain: Bool {
        true
    }

    private func setTheme(_ theme: HitoriTheme) {
        switch theme.getBaseTheme() {
        case .system:
            appearance = nil
        case .dark:
            appearance = NSAppearance(named: .darkAqua)
        case .light:
            appearance = NSAppearance(named: .aqua)
        }
    }

    private func setupWindowProperties() {
        standardWindowButton(.closeButton)?.isHidden
            = !windowStyle.trafficLights.contains(.close)
        standardWindowButton(.miniaturizeButton)?.isHidden
            = !windowStyle.trafficLights.contains(.minimize)
        standardWindowButton(.zoomButton)?.isHidden
            = !windowStyle.trafficLights.contains(.zoom)

        title = windowStyle.title
        titlebarAppearsTransparent = true

        if windowStyle.primary {
            collectionBehavior = .primary
        }

        if windowStyle.showTitle {
            titleVisibility = .visible
            isMovableByWindowBackground = false
        } else {
            titleVisibility = .hidden
            isMovableByWindowBackground = true
        }

        isOpaque = false
        backgroundColor = NSColor(calibratedWhite: 0, alpha: 0)
        appearance = nil // NSAppearance(named: .vibrantDark)
        center()
    }

    private func setupWindowContent() {
        guard let contentView else { return }

        setupContentViewLayer(contentView)
//        setupBlurView(contentView)
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
            NSHostingView(rootView: LandingView().environmentObject(self))
        case .welcome:
            NSHostingView(rootView: WelcomeView().environmentObject(self))
        case .workspace:
            NSHostingView(rootView: WorkspaceView().environmentObject(self))
        case .settings:
            NSHostingView(rootView: SettingsView().environmentObject(self))
        case .about:
            NSHostingView(rootView: AboutView().environmentObject(self))
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

    func windowWillClose(_: Notification) {
        print("[HitoriWindow] will close - \(windowType)")

        contentView?.subviews.forEach { $0.removeFromSuperview() }
        contentView = nil

        configThemeSink?.cancel()
        configThemeSink = nil

        windowManager.removeWindowController(self)
    }
}
