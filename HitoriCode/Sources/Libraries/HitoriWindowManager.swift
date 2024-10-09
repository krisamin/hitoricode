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

class HitoriWindowManager: ObservableObject {
    @Published var controllers: [NSWindowController] = []
    let appConfig = HitoriAppConfig()

    var controllersSink: AnyCancellable?

    init() {
        controllers = []

        controllersSink = $controllers.sink { _ in
            self.willUpdateWindows()
        }
    }

    private func willUpdateWindows() {
        print("check windows")
    }

    public func createLandingWindow() {
        createWindow(windowType: .landing)
    }

    public func createWelcomeWindow() {
        createWindow(windowType: .welcome)
    }

    public func createWorkspaceWindow() {
        createWindow(windowType: .workspace)
    }

    private func createWindow(windowType: HitoriWindowType) {
        let window = HitoriWindow(appConfig, windowType, self)
        let controller = NSWindowController(window: window)
        controllers.append(controller)
        controller.showWindow(nil)
    }

    public func closeWindow(window: HitoriWindow) {
        window.close()
        controllers.removeAll { $0.window === window }

        if controllers.isEmpty {
            NSApp.terminate(nil)
        }
    }
}

class HitoriWorkspaceConfig: ObservableObject {
    @Published var openFolder: String?
    @Published var openFile: String?
}
