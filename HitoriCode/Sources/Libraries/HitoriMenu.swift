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

class HitoriMenu {
    private static func getDefaultMenu() -> NSMenu {
        let appMenu = NSHostingMenu(rootView: Menu("HitoriCode") {
            Button("About HitoriCode") {}
            Button("Settings...") {}.keyboardShortcut(",")
            Divider()
            Button("Hide HitoriCode") {
                NSApplication.shared.hide(nil)
            }.keyboardShortcut("h")
            Button("Hide Others") {
                NSApplication.shared.hideOtherApplications(nil)
            }.keyboardShortcut("h", modifiers: [.command, .option])
            Divider()
            Button("Quit HitoriCode") {
                NSApplication.shared.terminate(nil)
            }.keyboardShortcut("q")
        })

        return appMenu
    }

    private static func getFileMenuItem() -> NSMenuItem {
        let fileMenuItem = NSMenuItem(title: "File", action: nil, keyEquivalent: "")
        fileMenuItem.submenu = NSHostingMenu(rootView: Group {
            Button("New File") {}
            Button("New Folder") {}
            Divider()
            Button("Open File...") {}
            Button("Open Folder...") {}
        })

        return fileMenuItem
    }

    private static func getEditMenuItem() -> NSMenuItem {
        let editMenuItem = NSMenuItem(title: "Edit", action: nil, keyEquivalent: "")
        editMenuItem.submenu = NSHostingMenu(rootView: Group {
            Button("Undo") {}
            Button("Redo") {}
            Divider()
            Button("Cut") {}
            Button("Copy") {}
            Button("Paste") {}
            Button("Select All") {}
        })

        return editMenuItem
    }

    private static func getDebugMenuItem() -> NSMenuItem {
        let debugMenuItem = NSMenuItem(title: "Debug", action: nil, keyEquivalent: "")
        debugMenuItem.submenu = NSHostingMenu(rootView: Group {
            Button("Debuuuuuuuuuuug...") {}
        })

        return debugMenuItem
    }

    private static func applyDefaultMenu() {
        NSApp.mainMenu = getDefaultMenu()
    }

    private static func setMenuItem(_ menuItem: NSMenuItem) {
        let menuItemTitle = menuItem.title
        let existingMenuItem = NSApp.mainMenu?.item(withTitle: menuItemTitle)

        if existingMenuItem == nil {
            NSApp.mainMenu?.addItem(menuItem)
        } else {
            existingMenuItem?.submenu = menuItem.submenu
        }
    }

    public static func applyMenu(_ windowType: HitoriWindowType) {
        HitoriMenu.applyDefaultMenu()
        switch windowType {
        case .welcome:
            HitoriMenu.setMenuItem(HitoriMenu.getDebugMenuItem())
        case .workspace:
            HitoriMenu.setMenuItem(HitoriMenu.getFileMenuItem())
            HitoriMenu.setMenuItem(HitoriMenu.getEditMenuItem())
            HitoriMenu.setMenuItem(HitoriMenu.getDebugMenuItem())
        default:
            break
        }
    }
}
