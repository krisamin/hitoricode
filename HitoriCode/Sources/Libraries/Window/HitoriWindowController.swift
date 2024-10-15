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
//  Created : 10/10/24
//  Package : HitoriCode
//  File    : HitoriWindowController.swift
//

import SwiftUI

/// 윈도우 컨트롤러 클래스
class HitoriWindowController: NSWindowController {
    init(window: HitoriWindow) {
        print("[HitoriWindowController] init")
        super.init(window: window)
    }

    deinit {
        print("[HitoriWindowController] deinit")
    }

    var hitoriWindow: HitoriWindow? {
        window as? HitoriWindow
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
