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
//  File    : WorkspaceView.swift
//

import AppKit
import SwiftUI

struct WorkspaceView: View {
    @State private var editorContent = ""

    var body: some View {
        BackgroundView {
            VStack {
                CodeEditorView(text: $editorContent)
            }
        }
    }
}

struct CodeEditorView: NSViewRepresentable {
    @Binding var text: String

    func makeNSView(context: Context) -> NSScrollView {
        let scrollView = NSScrollView()
        let textView = NSTextView()

        scrollView.documentView = textView
        textView.isRichText = false
        let font = NSFont(name: "goorm Sans Code 400", size: 20)!
        textView.typingAttributes = [
            .font: font,
            .ligature: true,
            .foregroundColor: NSColor.white
        ]

        textView.delegate = context.coordinator
        textView.backgroundColor = NSColor.clear
        textView.textContainer?.lineFragmentPadding = 0
        scrollView.backgroundColor = NSColor.clear
        scrollView.drawsBackground = false
        textView.autoresizingMask = [.width]
        textView.translatesAutoresizingMaskIntoConstraints = true

        return scrollView
    }

    func updateNSView(_ nsView: NSScrollView, context _: Context) {
        guard let textView = nsView.documentView as? NSTextView else { return }
        if textView.string != text {
            let selectedRanges = textView.selectedRanges
            textView.string = text
            textView.selectedRanges = selectedRanges
            highlightSyntax(in: textView)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, NSTextViewDelegate {
        var parent: CodeEditorView

        init(_ parent: CodeEditorView) {
            self.parent = parent
        }

        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else { return }
            parent.text = textView.string
            parent.highlightSyntax(in: textView)
        }
    }

    func highlightSyntax(in textView: NSTextView) {
        let attributedString = NSMutableAttributedString(string: textView.string)
        let fullRange = NSRange(location: 0, length: attributedString.length)
        let font = textView.font!
        attributedString.addAttributes(
            [
                .font: font,
                .ligature: true,
                .foregroundColor: NSColor.white
            ],
            range: fullRange
        )

        let keywords = [
            ("hitori", NSColor(red: 237 / 255, green: 184 / 255, blue: 197 / 255, alpha: 1)),
            ("nijika", NSColor(red: 231 / 255, green: 212 / 255, blue: 124 / 255, alpha: 1)),
            ("ryo", NSColor(red: 64 / 255, green: 97 / 255, blue: 161 / 255, alpha: 1)),
            ("kita", NSColor(red: 210 / 255, green: 86 / 255, blue: 78 / 255, alpha: 1))
        ]

        for (keyword, color) in keywords {
            let regex = try? NSRegularExpression(pattern: "\\b\(keyword)\\b", options: .caseInsensitive)
            regex?.enumerateMatches(in: textView.string, options: [], range: fullRange) { match, _, _ in
                if let matchRange = match?.range {
                    attributedString.addAttribute(.foregroundColor, value: color, range: matchRange)
                }
            }
        }

        let selectedRanges = textView.selectedRanges
        textView.textStorage?.setAttributedString(attributedString)
        textView.selectedRanges = selectedRanges
    }
}
