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
//  File    : HitoriMenu.swift
//

import SwiftUI

enum HitoriMenuType {
    case none, base, welcome, workspace
}

class HitoriMenu: NSMenu {
    private var menuType: HitoriMenuType = .none

    init(_ menuType: HitoriMenuType) {
        print("[HitoriMenu] init - \(menuType)")
        super.init(title: "HitoriCode - \(menuType)")
        self.menuType = menuType
        setupMenu()
    }

    deinit {
        print("[HitoriMenu] deinit")
    }

    @available(*, unavailable)
    required init(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addMenu(_ title: String, @ViewBuilder content: () -> some View) {
        let menuItem = NSMenuItem(title: title, action: nil, keyEquivalent: "")
        menuItem.submenu = NSHostingMenu(rootView: content())
        addItem(menuItem)
    }

    private func setupMenu() {
        addMenu("HitoriCode") { DefaultMenu() }

        switch menuType {
        case .welcome:
            addMenu("Window") { WindowMenu() }
        case .workspace:
            addMenu("File") { FileMenu() }
            addMenu("Edit") { EditMenu() }
            addMenu("Window") { WindowMenu() }
        case .base:
            addMenu("Window") { WindowMenu() }
        default:
            break
        }
    }
}
