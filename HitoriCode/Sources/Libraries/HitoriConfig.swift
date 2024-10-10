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

enum HitoriBaseTheme {
    case system, dark, light
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

enum HitoriLaunchWindow {
    case welcome, workspace
}

class HitoriConfig: ObservableObject {
    static let shared = HitoriConfig()

    @Published var firstLaunch: Bool = true
    @Published var theme: HitoriTheme = .system
    @Published var recentItems: [String] = []
    @Published var launchWindow: HitoriLaunchWindow = .welcome

//    var themeSink: AnyCancellable?
//    var recentItemsSink: AnyCancellable?
//    var launchWindowSink: AnyCancellable?

    init() {
        // TODO: 시스템 설정으로 가져와야 함. (재시작 시 유지되어야 함)
        firstLaunch = true
        theme = .system
        recentItems = []
        launchWindow = .welcome

//        themeSink = $theme.sink { _ in
//            self.willUpdateTheme()
//        }
//        recentItemsSink = $recentItems.sink { _ in
//            self.willUpdateRecentItems()
//        }
//        launchWindowSink = $launchWindow.sink { _ in
//            self.willUpdateLaunchWindow()
//        }
    }

//    private func willUpdateTheme() {
//        print("check theme")
//    }
//
//    private func willUpdateRecentItems() {
//        print("check recentItems")
//    }
//
//    private func willUpdateLaunchWindow() {
//        print("chekc launchWindow")
//    }

    public func addRecentItem(_ item: String) {
        recentItems.append(item)
    }
}
