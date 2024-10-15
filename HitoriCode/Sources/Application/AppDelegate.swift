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

/**
    Main Application Delegate for Managing the Application Lifecycle
 */
class AppDelegate: NSObject, NSApplicationDelegate {
    private let windowManager = HitoriWindowManager.shared

    func applicationDidFinishLaunching(_: Notification) {
        print("init")
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
