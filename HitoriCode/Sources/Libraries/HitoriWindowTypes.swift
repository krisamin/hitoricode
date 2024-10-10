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
//  File    : HitoriWindowTypes.swift
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
