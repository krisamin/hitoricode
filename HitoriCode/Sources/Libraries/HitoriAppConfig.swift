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
    case light
    case dark
    case system
}

class HitoriAppConfig: ObservableObject {
    @Published var firstLaunch: Bool = true
    @Published var theme: HitoriTheme = .system
    @Published var recentItems: [String] = []

    var firstLaunchSink: AnyCancellable?
    var themeSink: AnyCancellable?
    var recentItemsSink: AnyCancellable?

    init() {
        firstLaunch = true
        theme = .system
        recentItems = []

        firstLaunchSink = $firstLaunch.sink { _ in
            self.willUpdateFirstLaunch()
        }
        themeSink = $theme.sink { _ in
            self.willUpdateTheme()
        }
        recentItemsSink = $recentItems.sink { _ in
            self.willUpdateRecentItems()
        }
    }

    private func willUpdateFirstLaunch() {
        print("check firstLaunch")
    }

    private func willUpdateTheme() {
        print("check theme")
    }

    private func willUpdateRecentItems() {
        print("check recentItems")
    }

    public func addRecentItem(_ item: String) {
        recentItems.append(item)
    }
}
