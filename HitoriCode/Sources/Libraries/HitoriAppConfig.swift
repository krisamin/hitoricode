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
//  File    : HitoriAppConfig.swift
//

import Combine

enum HitoriTheme {
    case light, dark, system
}

enum HitoriLaunchWindow {
    case welcome, workspace
}

class HitoriAppConfig: ObservableObject {
    static let shared = HitoriAppConfig()

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
