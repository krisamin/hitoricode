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
//  File    : EditMenu.swift
//

import SwiftUI

struct EditMenu: View {
    var body: some View {
        VStack {
            Button("Undo") {}.keyboardShortcut("z")
            Button("Redo") {}.keyboardShortcut("z", modifiers: [.command, .shift])
            Divider()
            Button("Cut") {}.keyboardShortcut("x")
            Button("Copy") {}.keyboardShortcut("c")
            Button("Paste") {}.keyboardShortcut("v")
            Divider()
            Button("Find") {}.keyboardShortcut("f")
            Button("Replace") {}.keyboardShortcut("f", modifiers: [.command, .option])
            Divider()
            Button("Select All") {}.keyboardShortcut("a")
        }
    }
}
