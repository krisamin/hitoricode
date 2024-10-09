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
    @Published var controllers: [NSWindowController] = []
    @Published var currentFocusedType: HitoriWindowType?

    let appConfig = HitoriAppConfig()

    var controllersSink: AnyCancellable?

    init() {
        controllers = []

        controllersSink = $controllers.sink { _ in
            self.willUpdateWindows()
        }

        // TODO: 처음 실행인지, Welcome or Workspace 설정인지 확인 후 알맞은 윈도우 생성
        createWorkspaceWindow()
    }

    private func createWindow(windowType: HitoriWindowType) {
        let window = HitoriWindow(appConfig, windowType, self)
        let controller = NSWindowController(window: window)
        controllers.append(controller)
        controller.showWindow(nil)
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

    public func closeWindow(window: HitoriWindow) {
        window.close()
        controllers.removeAll { $0.window === window }
    }
}

class HitoriWorkspaceConfig: ObservableObject {
    @Published var openFolder: String?
    @Published var openFile: String?
}
