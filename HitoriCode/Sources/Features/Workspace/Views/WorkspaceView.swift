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
import Foundation
import SwiftUI

struct WorkspaceView: View {
    @ObservedObject var windowManager: HitoriWindowManager
    @ObservedObject var appConfig: HitoriAppConfig

    var window: HitoriWindow

    @State private var editorContent = ""
    @State private var lsp: LanguageServerInteraction?

    var body: some View {
        VStack {
            CodeEditorView(text: $editorContent)
            VStack {
                ForEach(appConfig.recentItems, id: \.self) { item in
                    Text(item)
                }
            }
            HStack {
                Button("Start LSP") {
                    startLSPServer()
                }
                Button("Add Recent") {
                    appConfig.addRecentItem("Item - \(Date().timeIntervalSince1970)")
                }
                Button("Close Window") {
                    windowManager.closeWindow(window: window)
                }
            }
        }
        .onAppear(
            perform: {
                setupLSP()
            }
        )
        .frame(minWidth: 400, maxWidth: .infinity, minHeight: 300, maxHeight: .infinity)
        .background(Color("Background"))
    }

    private func setupLSP() {
        lsp = LanguageServerInteraction(serverPath: "/Users/krisamin/.nvm/versions/node/v18.20.4/bin/node")
    }

    private func startLSPServer() {
        lsp?.startServer()
        sendInitializeRequest()
    }

    private func sendInitializeRequest() {
        guard let lsp, let processId = lsp.processId else { return }
        let request = LSPRequests.initialize(processId: processId)
        lsp.sendRequest(request)
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
            "--stdio"
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
            guard let self else { return }
            let data = handle.availableData
            handleReceivedData(data)
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
        let headerData = responseBuffer.subdata(in: 0 ..< headerRange.lowerBound)
        guard let contentLength = parseContentLength(from: String(data: headerData, encoding: .utf8)) else {
            return nil
        }

        let totalMessageLength = headerRange.upperBound + contentLength
        guard responseBuffer.count >= totalMessageLength else { return nil }

        let messageData = responseBuffer.subdata(in: headerRange.upperBound ..< totalMessageLength)
        responseBuffer.removeSubrange(0 ..< totalMessageLength)
        return String(data: messageData, encoding: .utf8)
    }

    private func parseContentLength(from header: String?) -> Int? {
        guard let header else { return nil }
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

enum LSPRequests {
    static func initialize(processId: Int32) -> String {
        """
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

// #Preview {
//    WorkspaceView()
//        .frame(width: 600, height: 600)
// }
