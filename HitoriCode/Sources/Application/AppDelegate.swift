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
//  Created : 10/8/24
//  Package : HitoriCode
//  File    : AppDelegate.swift
//

import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    let windowManager = HitoriWindowManager()

    func applicationDidFinishLaunching(_: Notification) {
        windowManager.newStart()
    }

    func applicationShouldHandleReopen(_: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if !flag {
            windowManager.newStart()
        }
        return true
    }

    func applicationDidBecomeActive(_: Notification) {}

    func applicationWillTerminate(_: Notification) {}

    func applicationSupportsSecureRestorableState(_: NSApplication) -> Bool {
        true
    }
}
