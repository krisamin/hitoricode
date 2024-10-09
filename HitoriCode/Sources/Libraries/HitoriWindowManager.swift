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

    public func createWindow() {
        let window = HitoriWindow(appConfig)
        let controller = NSWindowController(window: window)
        controllers.append(controller)
        controller.showWindow(nil)
    }
}
