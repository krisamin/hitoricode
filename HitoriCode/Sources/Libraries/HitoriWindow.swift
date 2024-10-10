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

enum HitoriWindowTrafficLight {
    case close, minimize, zoom
}

/// 윈도우 스타일
class HitoriWindowStyle {
    let contentRect: NSRect
    let styleMask: NSWindow.StyleMask
    let trafficLights: [HitoriWindowTrafficLight]
    let title: String
    let showTitle: Bool
    let primary: Bool
    let solo: Bool

    init(
        contentRect: NSRect,
        trafficLights: [HitoriWindowTrafficLight] = [],
        title: String = "",
        showTitle: Bool = false,
        primary: Bool = false,
        solo: Bool = false
    ) {
        self.contentRect = contentRect
        self.trafficLights = trafficLights
        var styleMask: NSWindow.StyleMask = [.fullSizeContentView]
        if trafficLights.count != 0 {
            styleMask.insert(.titled)
        }
        if trafficLights.contains(.close) {
            styleMask.insert(.closable)
        }
        if trafficLights.contains(.minimize) {
            styleMask.insert(.miniaturizable)
        }
        if trafficLights.contains(.zoom) {
            styleMask.insert(.resizable)
        }
        self.styleMask = styleMask
        self.title = title
        self.showTitle = showTitle
        self.primary = primary
        self.solo = solo
    }
}

/// 윈도우 타입
enum HitoriWindowType {
    case landing
    case welcome
    case workspace
    case settings
    case about

    /// 윈도우 타입에 맞는 스타일 반환
    func getWindowStyle() -> HitoriWindowStyle {
        switch self {
        case .landing:
            HitoriWindowStyle(
                contentRect: NSRect(x: 0, y: 0, width: 400, height: 400),
                primary: true
            )
        case .welcome:
            HitoriWindowStyle(
                contentRect: NSRect(x: 0, y: 0, width: 600, height: 400),
                trafficLights: [.close]
            )
        case .workspace:
            HitoriWindowStyle(
                contentRect: NSRect(x: 0, y: 0, width: 1200, height: 800),
                trafficLights: [.close, .minimize, .zoom],
                title: "HitoriCode",
                showTitle: true,
                primary: true
            )
        case .settings:
            HitoriWindowStyle(
                contentRect: NSRect(x: 0, y: 0, width: 800, height: 400),
                trafficLights: [.close],
                title: "Settings",
                showTitle: true,
                solo: true
            )
        case .about:
            HitoriWindowStyle(
                contentRect: NSRect(x: 0, y: 0, width: 300, height: 200),
                trafficLights: [.close],
                solo: true
            )
        }
    }
}

/// 윈도우 클래스
class HitoriWindow: NSWindow, NSWindowDelegate, ObservableObject {
    @ObservedObject var appConfig: HitoriAppConfig
    @ObservedObject var windowManager: HitoriWindowManager
    let windowType: HitoriWindowType
    let windowStyle: HitoriWindowStyle

    init(
        _ appConfig: HitoriAppConfig,
        _ windowType: HitoriWindowType,
        _ windowManager: HitoriWindowManager
    ) {
        self.appConfig = appConfig
        self.windowType = windowType
        self.windowManager = windowManager
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
    }

    override var canBecomeKey: Bool {
        true
    }

    override var canBecomeMain: Bool {
        true
    }

    func windowDidBecomeKey(_: Notification) {
        print("[HitoriWindow] focus - \(windowType)")
        windowManager.currentFocusedType = windowType
        HitoriMenu.applyMenu(windowType)
    }

    func windowDidResignKey(_: Notification) {
        print("[HitoriWindow] unfocus - \(windowType)")
        windowManager.currentFocusedType = nil
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
            NSHostingView(rootView: LandingView(
                appConfig: appConfig,
                windowManager: windowManager,
                window: self
            ))
        case .welcome:
            NSHostingView(rootView: WelcomeView(
                appConfig: appConfig,
                windowManager: windowManager,
                window: self
            ))
        case .workspace:
            NSHostingView(
                rootView: WorkspaceView(
                    appConfig: appConfig,
                    windowManager: windowManager,
                    window: self
                )
            )
        case .settings:
            NSHostingView(rootView: SettingsView(
                appConfig: appConfig,
                windowManager: windowManager,
                window: self
            ))
        case .about:
            NSHostingView(rootView: AboutView(
                appConfig: appConfig,
                windowManager: windowManager,
                window: self
            ))
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
        windowManager.removeWindow(self)
    }
}
