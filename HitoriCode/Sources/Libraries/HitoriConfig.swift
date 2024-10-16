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
//  File    : HitoriConfig.swift
//

import Combine
import Foundation

/// Base theme for set appearance of window
enum HitoriBaseTheme {
    /**
     Following System appearance

     ```swift
      NSWindow.appearance = nil
     ```
     */
    case system
    /**
     Use Dark appearance for application

     ```swift
      NSWindow.appearance = NSAppearance(named: .darkAqua)
     ```
     */
    case dark
    /**
     Use Light appearance for application

     ```swift
      NSWindow.appearance = NSAppearance(named: .aqua)
     ```
     */
    case light
}

enum HitoriTheme {
    case system, dark, light, hitori, nijika, ryo, kita

    func getBaseTheme() -> HitoriBaseTheme {
        switch self {
        case .system:
            .system
        case .dark, .kita, .ryo:
            .dark
        case .light, .hitori, .nijika:
            .light
        }
    }

    func getBackgroundName() -> String {
        switch self {
        case .system, .light, .dark:
            "Background"
        case .hitori:
            "BackgroundHitori"
        case .nijika:
            "BackgroundNijika"
        case .ryo:
            "BackgroundRyo"
        case .kita:
            "BackgroundKita"
        }
    }
}

/// Window type enum for store Launch window
enum HitoriLaunchWindow {
    /// Use Welcome window for launch
    ///
    /// Default value on first launch
    case welcome
    /// Use Workspace window for launch
    case workspace
}

/**
    Config state object for Hitori
 */
class HitoriConfig: ObservableObject {
    /// The shared Hitori config object.
    public static let shared = HitoriConfig()

    /// Application first launch flag
    @Published public var firstLaunch: Bool = true
    /// Application theme
    @Published public var theme: HitoriTheme = .system
    // TODO: 최근 파일 혹은 폴더 목록을 저장할 수 있도록 변경 : String -> 별도 Object
    /// Recent file or folder list
    @Published public var recentItems: [HitoriFileItem] = []
    /// Application launch window type
    @Published public var launchWindow: HitoriLaunchWindow = .welcome

    public init() {
        // TODO: 시스템 설정으로 가져와야 함. (재시작 시 유지되어야 함)
        firstLaunch = true
        theme = .system
        recentItems = []
        launchWindow = .welcome
    }

    /**
        Add item to Recent item list

        - Parameter item: Recent item to add
     */
    public func addRecentItem(_ item: HitoriFileItem) {
        recentItems.append(item)
    }
}
