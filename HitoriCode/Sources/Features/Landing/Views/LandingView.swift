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
//  File    : LandingView.swift
//

import SwiftUI

struct LandingView: View {
    var body: some View {
        VStack {
            Text("Welcome! this is the landing view.")
            Button("Start") {}

            Button("새 창 열기") {
                let newWindow = NSWindow(contentRect: NSRect(x: 100, y: 100, width: 300, height: 200),
                                         styleMask: [.titled, .closable, .miniaturizable, .resizable],
                                         backing: .buffered,
                                         defer: false)
                newWindow.styleMask.remove(.titled)
                newWindow.styleMask.insert(.fullSizeContentView)
                newWindow.titlebarAppearsTransparent = true
                newWindow.titleVisibility = .hidden
                newWindow.isMovableByWindowBackground = true
                newWindow.contentView = NSHostingView(rootView: WelcomeView())
                newWindow.makeKeyAndOrderFront(nil)
            }
        }
    }
}

#Preview {
    LandingView()
}

import Cocoa
