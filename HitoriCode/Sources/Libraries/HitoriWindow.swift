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

class HitoriWindowController: NSWindowController {
    init(window: HitoriWindow) {
        print("[HitoriWindowController] init")
        super.init(window: window)
    }

    deinit {
        print("[HitoriWindowController] deinit")
    }

    var hitoriWindow: HitoriWindow? {
        window as? HitoriWindow
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol HitoriWindowProtocol: NSWindow {
    var windowType: HitoriWindowType { get }
}

/// 윈도우 클래스
class HitoriWindow: NSWindow, NSWindowDelegate, ObservableObject, HitoriWindowProtocol {
    @ObservedObject var appConfig = HitoriAppConfig.shared
    @ObservedObject var windowManager = HitoriWindowManager.shared
    let windowType: HitoriWindowType
    let windowStyle: HitoriWindowStyle

    var appConfigThemeSink: AnyCancellable?

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

        appConfigThemeSink = appConfig.$theme.sink { self.setTheme($0) }
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
        switch theme {
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

        appConfigThemeSink?.cancel()
        appConfigThemeSink = nil

        windowManager.removeWindowController(self)
    }
}
