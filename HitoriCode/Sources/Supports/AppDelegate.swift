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

import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_: Notification) {
        let window = CustomWindow(
            contentRect: .init(origin: .zero, size: CGSize(width: 800, height: 800)),
            styleMask: [.fullSizeContentView, .resizable],
            backing: .buffered,
            defer: false
        )

        let hostingView = NSHostingView(rootView: WorkspaceView())

        window.contentView = hostingView
        window.isOpaque = false
//        window.backgroundColor = NSColor(calibratedHue: 0, saturation: 0, brightness: 1, alpha: 0.5)
        window.isMovableByWindowBackground = true
        window.center()

        if let contentView = window.contentView {
            contentView.wantsLayer = true
            contentView.layer?.cornerRadius = 10
            contentView.layer?.masksToBounds = true
            contentView.layer?.backgroundColor = NSColor(
                calibratedHue: 0,
                saturation: 0,
                brightness: 1,
                alpha: 0.5
            ).cgColor

            // 아마 여기서 CiFilter 쓸 수 있을거임 ㅋ
        }

        let windowController = NSWindowController()
        windowController.contentViewController = window.contentViewController
        windowController.window = window
        windowController.showWindow(nil)
    }

    func applicationWillTerminate(_: Notification) {}

    func applicationSupportsSecureRestorableState(_: NSApplication) -> Bool {
        true
    }
}

class CustomWindow: NSWindow {
    override var canBecomeKey: Bool {
        true
    }

    override var canBecomeMain: Bool {
        true
    }
}
