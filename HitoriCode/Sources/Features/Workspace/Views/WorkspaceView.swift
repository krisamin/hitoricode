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

// MARK: - SwiftUI Views

struct WorkspaceView: View {
    @State private var editorContent = ""
    @State private var cursorPosition = CursorPosition()
    @State private var lineCount = 1

    var body: some View {
        BackgroundView {
            CodeEditorView(text: $editorContent, cursorPosition: $cursorPosition, lineCount: $lineCount)
//            Text("row \(cursorPosition.row), column \(cursorPosition.column)")
            VStack {
                Button("LSP REQUEST") {
                    LSPRequests.initialize(processId: ProcessInfo.processInfo.processIdentifier)
                }
            }
        }
    }
}

// MARK: - Models

struct CursorPosition: Equatable {
    var row: Int
    var column: Int

    init(row: Int = 1, column: Int = 1) {
        self.row = row
        self.column = column
    }
}

// MARK: - AppKit Views

class LineNumberView: NSRulerView {
    var lineCount: Int = 1
    var scrollPosition: CGFloat = 0

    override var isFlipped: Bool { true }

    override init(scrollView: NSScrollView?, orientation: NSRulerView.Orientation) {
        super.init(scrollView: scrollView, orientation: orientation)
    }

    @available(*, unavailable)
    required init(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ dirtyRect: NSRect) {
        NSColor.clear.setFill()
        dirtyRect.fill()

        let separatorColor = NSColor.gray.withAlphaComponent(0.3)
        separatorColor.setStroke()
        let path = NSBezierPath()
        path.move(to: NSPoint(x: bounds.width - 0.5, y: dirtyRect.minY))
        path.line(to: NSPoint(x: bounds.width - 0.5, y: dirtyRect.maxY))
        path.stroke()

        drawHashMarksAndLabels(in: dirtyRect)
    }

    override func drawHashMarksAndLabels(in rect: NSRect) {
        guard let textView = clientView as? NSTextView,
              let layoutManager = textView.layoutManager else { return }
//        let textContainer = textView.textContainer

        let visibleRect = visibleRect
        let font = NSFont(name: "goorm Sans Code 400", size: 20) ?? .systemFont(ofSize: 20)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: NSColor.gray
        ]

        let content = textView.string as NSString
        let range = NSRange(location: 0, length: content.length)
        let extraSpace: CGFloat = 10.0
        let extendedVisibleRect = visibleRect.insetBy(dx: 0, dy: -extraSpace)

        // TODO: 마지막 라인 비어있을때 표시안되는 문제 해결해야함
        layoutManager.enumerateLineFragments(forGlyphRange: range) { rect, _, _, glyphRange, _ in
            let lineRect = rect.offsetBy(dx: 0, dy: -self.scrollPosition)
            guard lineRect.intersects(extendedVisibleRect) else { return }

            let characterRange = layoutManager.characterRange(forGlyphRange: glyphRange, actualGlyphRange: nil)
            let lineNumber = content.substring(
                with: NSRange(
                    location: 0,
                    length: characterRange.location
                )
            ).components(separatedBy: .newlines).count

            let lineNumberString = "\(lineNumber)"

            let size = lineNumberString.size(withAttributes: attributes)
            let point = NSPoint(x: self.bounds.width - size.width - 8, y: lineRect.minY)
            lineNumberString.draw(at: point, withAttributes: attributes)
        }
    }
}

// MARK: - NSViewRepresentable

struct CodeEditorView: NSViewRepresentable {
    @Binding var text: String
    @Binding var cursorPosition: CursorPosition
    @Binding var lineCount: Int

    func makeNSView(context: Context) -> NSScrollView {
        let scrollView = NSScrollView()
        let textView = NSTextView()

        configureTextView(textView)
        configureScrollView(scrollView, with: textView)
        setupLineNumberView(for: scrollView, textView: textView)

        textView.delegate = context.coordinator
        textView.textStorage?.delegate = context.coordinator

        NotificationCenter.default.addObserver(
            context.coordinator,
            selector: #selector(Coordinator.textDidScroll(_:)),
            name: NSView.boundsDidChangeNotification,
            object: scrollView.contentView
        )

        return scrollView
    }

    func updateNSView(_ nsView: NSScrollView, context _: Context) {
        guard let textView = nsView.documentView as? NSTextView else { return }
        if textView.string != text {
            textView.string = text
            updateLineCount(textView)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    // MARK: - Helper Methods

    private func configureTextView(_ textView: NSTextView) {
        textView.isRichText = false
        textView.font = NSFont(name: "goorm Sans Code 400", size: 20) ?? .systemFont(ofSize: 20)
        textView.textColor = .white
        textView.backgroundColor = .clear
        textView.drawsBackground = false
        textView.autoresizingMask = [.width, .height]
        textView.isVerticallyResizable = true
        textView.isHorizontallyResizable = false
        textView.textContainer?.widthTracksTextView = true
        textView.textContainer?.containerSize = NSSize(width: 0, height: CGFloat.greatestFiniteMagnitude)
        textView.maxSize = NSSize(width: .greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        textView.minSize = .zero
        textView.isAutomaticQuoteSubstitutionEnabled = false
        textView.enabledTextCheckingTypes = 0
        textView.textContainer?.lineFragmentPadding = 8
    }

    private func configureScrollView(_ scrollView: NSScrollView, with textView: NSTextView) {
        scrollView.documentView = textView
        scrollView.hasHorizontalScroller = false
        scrollView.hasVerticalScroller = true
        scrollView.scrollerStyle = .overlay
        scrollView.horizontalScrollElasticity = .none
        scrollView.backgroundColor = .clear
        scrollView.drawsBackground = false
    }

    private func setupLineNumberView(for scrollView: NSScrollView, textView: NSTextView) {
        let lineNumberView = LineNumberView(scrollView: scrollView, orientation: .verticalRuler)
        lineNumberView.clientView = textView
        lineNumberView.ruleThickness = 50

        scrollView.verticalRulerView = lineNumberView
        scrollView.hasVerticalRuler = true
        scrollView.rulersVisible = true
    }

    private func updateCursorPosition(_ textView: NSTextView) {
        let selectedRange = textView.selectedRange()
        let substring = (textView.string as NSString).substring(to: selectedRange.location)
        let lines = substring.components(separatedBy: .newlines)
        let row = lines.count
        let column = lines.last?.count ?? 0

        DispatchQueue.main.async {
            cursorPosition = CursorPosition(row: row, column: column + 1)
        }
    }

    private func updateLineCount(_ textView: NSTextView) {
        let text = textView.string
        let lineCount = text.components(separatedBy: .newlines).count

        DispatchQueue.main.async {
            self.lineCount = lineCount
            textView.enclosingScrollView?.verticalRulerView?.needsDisplay = true
        }
    }

//    private func updateLineCount(_ textView: NSTextView) {
//        let layoutManager = textView.layoutManager!
//        let numberOfGlyphs = layoutManager.numberOfGlyphs
//        var lineCount = 0
//        var index = 0
//
//        while index < numberOfGlyphs {
//            let lineRange = (textView.string as NSString).lineRange(for: NSRange(location: index, length: 0))
//            index = NSMaxRange(lineRange)
//            lineCount += 1
//        }
//
//        DispatchQueue.main.async {
//            self.lineCount = lineCount
//            textView.enclosingScrollView?.verticalRulerView?.needsDisplay = true
//        }
//    }

    // MARK: - Coordinator

    class Coordinator: NSObject, NSTextViewDelegate, NSTextStorageDelegate {
        var parent: CodeEditorView

        init(_ parent: CodeEditorView) {
            self.parent = parent
        }

        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else { return }
            parent.text = textView.string
            parent.updateCursorPosition(textView)
            parent.updateLineCount(textView)
        }

        func textViewDidChangeSelection(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else { return }
            parent.updateCursorPosition(textView)
        }

        @objc func textDidScroll(_ notification: Notification) {
            guard let scrollView = notification.object as? NSClipView,
                  let textView = scrollView.documentView as? NSTextView,
                  let lineNumberView = textView.enclosingScrollView?.verticalRulerView as? LineNumberView
            else {
                return
            }

            lineNumberView.scrollPosition = scrollView.bounds.origin.y
            lineNumberView.needsDisplay = true
        }

        func textStorage(
            _ textStorage: NSTextStorage,
            didProcessEditing _: NSTextStorageEditActions,
            range _: NSRange,
            changeInLength _: Int
        ) {
            guard let textView = textStorage.layoutManagers.first?.textViewForBeginningOfSelection else { return }
            DispatchQueue.main.async {
                self.parent.updateLineCount(textView)
            }
        }
    }
}
