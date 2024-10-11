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
//  File    : FileMenu.swift
//

import SwiftUI

struct FileMenu: View {
    @ObservedObject private var windowManager = HitoriWindowManager.shared

    var body: some View {
        Button("New File") {}.keyboardShortcut("n")
        Button("New Window") {
            windowManager.newWindow()
        }.keyboardShortcut("n", modifiers: [.command, .shift])
        Divider()
        Button("Open File...") {}
        Button("Open Folder...") {}
    }
}
