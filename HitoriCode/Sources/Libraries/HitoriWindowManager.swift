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
    static let shared = HitoriWindowManager()

    @Published var windowControllers: [HitoriWindowController] = []
    let appConfig = HitoriAppConfig.shared

    var windowControllersSink: AnyCancellable?

    init() {
        print("[HitoriWindowManager] init")

        windowControllersSink = $windowControllers.sink { windowControllers in
            self.willUpdateWindowControllers(windowControllers)
        }
    }

    private func willUpdateWindowControllers(_ windowControllers: [HitoriWindowController]) {
        print("[HitoriWindowManager] count - \(self.windowControllers.count) -> \(windowControllers.count)")
    }

    private func createWindow(_ windowType: HitoriWindowType) {
        print("[HitoriWindowManager] create - \(windowType)")
        let window = HitoriWindow(windowType)
        let windowController = HitoriWindowController(window: window)
        windowControllers.append(windowController)
        windowController.showWindow(nil)
    }

    private func createWindowWithCheck(_ windowType: HitoriWindowType) {
        if let controller = windowControllers.first(where: { $0.hitoriWindow?.windowType == windowType }) {
            controller.showWindow(nil)
        } else {
            createWindow(windowType)
        }
    }

    public func newStart() {
        // TODO: 처음 실행인지 -> createWindow .landing, 아닌 경우 -> newWindow
        createWindow(.landing)
//         newWindow()
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

    public func removeWindowController(_ window: HitoriWindow) {
        print("[HitoriWindowManager] remove - \(window.windowType)")
        window.windowController = nil
        windowControllers.removeAll { $0.window === window }
    }
}

class HitoriWorkspaceConfig: ObservableObject {
    @Published var openFolder: String?
    @Published var openFile: String?
}
