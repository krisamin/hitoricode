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
import Foundation
import SwiftUI

struct ContentView: View {
    @State private var editorContent = ""
    @State private var lsp: LanguageServerInteraction?

    var body: some View {
        VStack {
            CodeEditorView(text: $editorContent)
            HStack {
                Button("Start LSP") {
                    startLSPServer()
                }
            }
        }
        .onAppear {
            setupLSP()
        }
    }

    private func setupLSP() {
        lsp = LanguageServerInteraction(serverPath: "/Users/krisamin/.nvm/versions/node/v18.20.4/bin/node")
    }

    private func startLSPServer() {
        lsp?.startServer()
        sendInitializeRequest()
    }

    private func sendInitializeRequest() {
        guard let lsp = lsp, let processId = lsp.processId else { return }
        let request = LSPRequests.initialize(processId: processId)
        lsp.sendRequest(request)
    }
}

struct CodeEditorView: NSViewRepresentable {
    @Binding var text: String

    func makeNSView(context: Context) -> NSScrollView {
        let scrollView = NSScrollView()
        let textView = NSTextView()
        configureTextView(textView)
        scrollView.documentView = textView
        scrollView.drawsBackground = false
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

    private func configureTextView(_ textView: NSTextView) {
        let font = NSFont(name: "goorm Sans Code 400", size: 20)!
        textView.isRichText = false
        textView.typingAttributes = [
            .font: font,
            .ligature: false,
            .foregroundColor: NSColor.black,
        ]
        textView.backgroundColor = NSColor.clear
        textView.autoresizingMask = [.width]
        textView.translatesAutoresizingMaskIntoConstraints = true
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
            [.font: font, .ligature: false, .foregroundColor: NSColor.black],
            range: fullRange)

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
            highlightKeyword(in: textView, keyword: keyword, color: color, fullRange: fullRange)
        }

        let selectedRanges = textView.selectedRanges
        textView.textStorage?.setAttributedString(attributedString)
        textView.selectedRanges = selectedRanges
    }

    private func highlightKeyword(in textView: NSTextView, keyword: String, color: NSColor, fullRange: NSRange) {
        let regex = try? NSRegularExpression(pattern: "\\b\(keyword)\\b", options: .caseInsensitive)
        regex?.enumerateMatches(in: textView.string, options: [], range: fullRange) { match, _, _ in
            if let matchRange = match?.range {
                let attributedString = NSMutableAttributedString(attributedString: textView.attributedString())
                attributedString.addAttribute(.foregroundColor, value: color, range: matchRange)
                textView.textStorage?.setAttributedString(attributedString)
            }
        }
    }
}

class LanguageServerInteraction {
    private let serverPath: String
    private var process: Process?
    private var inputPipe: Pipe?
    private var outputPipe: Pipe?
    private var errorPipe: Pipe?
    private var responseBuffer = Data()

    var processId: Int32?

    init(serverPath: String) {
        self.serverPath = serverPath
    }

    func startServer() {
        initializeProcess()
        do {
            try process?.run()
            processId = process?.processIdentifier
            print("Language server started with PID: \(processId ?? 0)")
            startReadingResponses()
            startReadingErrors()
        } catch {
            print("Failed to start language server: \(error)")
        }
    }

    func sendRequest(_ request: String) {
        let contentLength = request.utf8.count
        let fullRequest = "Content-Length: \(contentLength)\r\n\r\n\(request)"
        inputPipe?.fileHandleForWriting.write(fullRequest.data(using: .utf8)!)
        print("Sent request: \(fullRequest)")
    }

    private func initializeProcess() {
        process = Process()
        process?.executableURL = URL(fileURLWithPath: serverPath)
        process?.arguments = [
            "/Users/krisamin/.nvm/versions/node/v18.20.4/lib/node_modules/typescript-language-server/lib/cli.mjs",
            "--stdio",
        ]
        inputPipe = Pipe()
        outputPipe = Pipe()
        errorPipe = Pipe()
        process?.standardInput = inputPipe
        process?.standardOutput = outputPipe
        process?.standardError = errorPipe
    }

    private func startReadingResponses() {
        outputPipe?.fileHandleForReading.readabilityHandler = { [weak self] handle in
            guard let self = self else { return }
            let data = handle.availableData
            self.handleReceivedData(data)
        }
    }

    private func startReadingErrors() {
        errorPipe?.fileHandleForReading.readabilityHandler = { handle in
            let errorData = handle.availableData
            if let errorString = String(data: errorData, encoding: .utf8), !errorString.isEmpty {
                print("Server error: \(errorString)")
            }
        }
    }

    private func handleReceivedData(_ data: Data) {
        responseBuffer.append(data)
        while let message = extractMessageFromBuffer() {
            print("Received response: \(message)")
        }
    }

    private func extractMessageFromBuffer() -> String? {
        guard let headerRange = responseBuffer.range(of: Data("\r\n\r\n".utf8)) else { return nil }
        let headerData = responseBuffer.subdata(in: 0..<headerRange.lowerBound)
        guard let contentLength = parseContentLength(from: String(data: headerData, encoding: .utf8)) else {
            return nil
        }

        let totalMessageLength = headerRange.upperBound + contentLength
        guard responseBuffer.count >= totalMessageLength else { return nil }

        let messageData = responseBuffer.subdata(in: headerRange.upperBound..<totalMessageLength)
        responseBuffer.removeSubrange(0..<totalMessageLength)
        return String(data: messageData, encoding: .utf8)
    }

    private func parseContentLength(from header: String?) -> Int? {
        guard let header = header else { return nil }
        return
            header
            .components(separatedBy: "\r\n")
            .first(where: { $0.lowercased().starts(with: "content-length:") })
            .flatMap { Int($0.split(separator: ":")[1].trimmingCharacters(in: .whitespaces)) }
    }

    func stopServer() {
        process?.terminate()
        print("Language server stopped.")
    }
}

struct LSPRequests {
    static func initialize(processId: Int32) -> String {
        return """
            {
                "jsonrpc": "2.0",
                "id": 1,
                "method": "initialize",
                "params": {
                    "processId": \(processId),
                    "rootUri": null,
                    "capabilities": {}
                }
            }
            """
    }
}

#Preview {
    ContentView()
        .frame(width: 600, height: 600)
}
