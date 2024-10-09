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
        self.createWindow(windowType: .landing)
    }
    
    public func createWelcomeWindow() {
        self.createWindow(windowType: .welcome)
    }
    
    public func createWorkspaceWindow() {
        self.createWindow(windowType: .workspace)
    }

    private func createWindow(windowType: HitoriWindowType) {
        let window = HitoriWindow(appConfig, windowType)
        let controller = NSWindowController(window: window)
        controllers.append(controller)
        controller.showWindow(nil)
    }
}

class HitoriWorkspaceConfig: ObservableObject {
    @Published var openFolder: String? = nil
    @Published var openFile: String? = nil
}
