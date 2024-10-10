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
//  File    : HitoriWindowManager.swift
//

import Combine
import SwiftUI

/// 어플리케이션의 윈도우 관리를 담당하는 클래스
class HitoriWindowManager: ObservableObject {
    @Published var windows: [HitoriWindow]
    @Published var currentFocusedType: HitoriWindowType?
    let appConfig = HitoriAppConfig()

    var controllersSink: AnyCancellable?

    init() {
        windows = []

        controllersSink = $windows.sink { windows in
            self.willUpdateWindows(windows)
        }
    }

    private func willUpdateWindows(_ windows: [HitoriWindow]) {
        print("[HitoriWindowManager] count - \(self.windows.count) -> \(windows.count)")
    }

    private func createWindow(_ windowType: HitoriWindowType) {
        print("[HitoriWindowManager] create - \(windowType)")
        let window = HitoriWindow(appConfig, windowType, self)
        windows.append(window)
        window.makeKeyAndOrderFront(nil)
    }

    private func createWindowWithCheck(_ windowType: HitoriWindowType) {
        if let window = windows.first(where: { $0.windowType == windowType }) {
            window.makeKeyAndOrderFront(nil)
        } else {
            createWindow(windowType)
        }
    }

    public func newStart() {
        // TODO: 처음 실행인지 -> createWindow .landing, 아닌 경우 -> newWindow
        createWindow(.landing)
        // newWindow()
    }

    public func newWindow() {
        switch appConfig.launchWindow {
        case .welcome:
            createWindow(.welcome)
        case .workspace:
            createWindow(.workspace)
        }
    }

    public func openWorkspace() {
        createWindow(.workspace)
    }

    public func openSettings() {
        createWindowWithCheck(.settings)
    }

    public func openAbout() {
        createWindowWithCheck(.about)
    }

    public func removeWindow(_ window: HitoriWindow) {
        print("[HitoriWindowManager] remove - \(window.windowType)")
        windows.removeAll { $0 == window }
    }
}

class HitoriWorkspaceConfig: ObservableObject {
    @Published var openFolder: String?
    @Published var openFile: String?
}
