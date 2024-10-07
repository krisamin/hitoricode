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
//  Created : 10/7/24
//  Package : Editor
//  File    : ContentView.swift
//

import AppKit
import SwiftUI

struct ContentView: View {
    @State private var editorContent = ""

    var body: some View {
        VStack {
            CodeEditorView(text: $editorContent)
                .frame(minWidth: 300, minHeight: 200)
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
            .ligature: false,
            .foregroundColor: NSColor.black,
        ]

        textView.delegate = context.coordinator

        textView.backgroundColor = NSColor.clear
        scrollView.backgroundColor = NSColor.clear
        scrollView.drawsBackground = false

        textView.autoresizingMask = [.width]
        textView.translatesAutoresizingMaskIntoConstraints = true

        return scrollView
    }

    func updateNSView(_ nsView: NSScrollView, context: Context) {
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
                .ligature: false,
                .foregroundColor: NSColor.black,
            ],
            range: fullRange
        )

        let keywords = [
            ("칸나", NSColor(red: 55 / 255, green: 53 / 255, blue: 132 / 255, alpha: 1)),
            ("유니", NSColor(red: 183 / 255, green: 125 / 255, blue: 228 / 255, alpha: 1)),
            ("히나", NSColor(red: 242 / 255, green: 220 / 255, blue: 191 / 255, alpha: 1)),
            ("마시로", NSColor(red: 159 / 255, green: 62 / 255, blue: 65 / 255, alpha: 1)),
            ("리제", NSColor(red: 151 / 255, green: 27 / 255, blue: 47 / 255, alpha: 1)),
            ("타비", NSColor(red: 154 / 255, green: 218 / 255, blue: 255 / 255, alpha: 1)),
            ("시부키", NSColor(red: 194 / 255, green: 175 / 255, blue: 230 / 255, alpha: 1)),
            ("린", NSColor(red: 43 / 255, green: 102 / 255, blue: 192 / 255, alpha: 1)),
            ("나나", NSColor(red: 223 / 255, green: 118 / 255, blue: 133 / 255, alpha: 1)),
            ("리코", NSColor(red: 166 / 255, green: 208 / 255, blue: 166 / 255, alpha: 1)),
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

#Preview {
    ContentView()
        .frame(width: 600, height: 600)
}
