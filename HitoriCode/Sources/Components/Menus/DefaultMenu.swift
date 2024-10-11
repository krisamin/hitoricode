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
//  Created : 10/11/24
//  Package : HitoriCode
//  File    : DefaultMenu.swift
//

import SwiftUI

struct DefaultMenu: View {
    @ObservedObject private var windowManager = HitoriWindowManager.shared

    var body: some View {
        Button("About HitoriCode") {
            windowManager.openAbout()
        }
        Button("Settings...") {
            windowManager.openSettings()
        }.keyboardShortcut(",")
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
    }
}
