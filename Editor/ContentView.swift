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
    @State private var lsp: LanguageServerInteraction?

    var body: some View {
        VStack {
            CodeEditorView(text: $editorContent)
                .frame(minWidth: 300, minHeight: 200)
            HStack {
                Button("Start LSP Server") {
                    startLSPServer()
                }
                Button("Initialize LSP") {
                    initializeLSP()
                }
            }
        }
        .onAppear {
            setupLSP()
        }
    }

    // Set up the language server
    private func setupLSP() {
        lsp = LanguageServerInteraction(serverPath: "/Users/krisamin/.bun/bin/bun")
    }

    // Start the LSP server
    private func startLSPServer() {
        lsp?.startServer()
    }

    // Send an initialization request to the LSP server
    private func initializeLSP() {
        guard let lsp = lsp, let processId = lsp.processId else { return }

        let request = """
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

import Foundation

class LanguageServerInteraction {
    private let serverPath: String
    private var process: Process?
    private var inputPipe: Pipe?
    private var outputPipe: Pipe?
    private var errorPipe: Pipe?
    private var responseBuffer = Data() // Buffer to accumulate data until we have a full message

    var processId: Int32?

    init(serverPath: String) {
        self.serverPath = serverPath
    }

    // Starts the language server process
    func startServer() {
        process = Process()
        process?.executableURL = URL(fileURLWithPath: serverPath)
        process?.arguments = ["x", "--bun", "typescript-language-server", "--stdio"]

        inputPipe = Pipe()
        outputPipe = Pipe()
        errorPipe = Pipe()  // Capture errors in a separate pipe

        process?.standardInput = inputPipe
        process?.standardOutput = outputPipe
        process?.standardError = errorPipe

        do {
            try process?.run()
            processId = process?.processIdentifier
            print("Language server started with PID: \(processId ?? 0)")

            // Start reading the server's output and errors
            startReadingResponses()
            startReadingErrors()
        } catch {
            print("Failed to start language server: \(error)")
        }
    }

    // Sends an LSP request to the server
    func sendRequest(_ request: String) {
        let contentLength = request.utf8.count
        let header = "Content-Length: \(contentLength)\r\n\r\n"
        let fullRequest = header + request

        guard let inputPipe = inputPipe else { return }
        inputPipe.fileHandleForWriting.write(fullRequest.data(using: .utf8)!)
        print("Sent request: \(fullRequest)")
    }

    // Reads the server's responses asynchronously
    private func startReadingResponses() {
        outputPipe?.fileHandleForReading.readabilityHandler = { [weak self] handle in
            let data = handle.availableData
            guard let self = self, data.count > 0 else { return }
            self.handleReceivedData(data)
        }
    }

    // Reads the server's errors asynchronously
    private func startReadingErrors() {
        errorPipe?.fileHandleForReading.readabilityHandler = { handle in
            let errorData = handle.availableData
            if let errorString = String(data: errorData, encoding: .utf8), !errorString.isEmpty {
                print("Server error: \(errorString)")
            }
        }
    }

    // Handles incoming data from the server, parsing based on LSP protocol
    private func handleReceivedData(_ data: Data) {
        responseBuffer.append(data)

        while true {
            // Look for the LSP header terminator \r\n\r\n
            if let headerRange = responseBuffer.range(of: Data("\r\n\r\n".utf8)) {
                let headerData = responseBuffer.subdata(in: 0..<headerRange.lowerBound)

                // Parse the Content-Length header
                if let headerString = String(data: headerData, encoding: .utf8),
                   let contentLength = parseContentLength(from: headerString) {

                    // Calculate total message length
                    let messageLength = headerRange.upperBound + contentLength

                    // If we have the full message, process it
                    if responseBuffer.count >= messageLength {
                        let messageData = responseBuffer.subdata(in: headerRange.upperBound..<messageLength)

                        if let messageString = String(data: messageData, encoding: .utf8) {
                            print("Received response: \(messageString)")
                            // Here you can handle or dispatch the response as needed
                        }

                        // Remove the processed message from the buffer
                        responseBuffer.removeSubrange(0..<messageLength)
                    } else {
                        // Wait for more data
                        break
                    }
                } else {
                    print("Failed to parse Content-Length")
                    break
                }
            } else {
                // Header is incomplete, wait for more data
                break
            }
        }
    }

    // Parses the Content-Length from the LSP header
    private func parseContentLength(from header: String) -> Int? {
        let lines = header.components(separatedBy: "\r\n")
        for line in lines {
            if line.lowercased().starts(with: "content-length:") {
                if let value = line.split(separator: ":").last,
                   let contentLength = Int(value.trimmingCharacters(in: .whitespaces)) {
                    return contentLength
                }
            }
        }
        return nil
    }

    // Stop the server if needed
    func stopServer() {
        process?.terminate()
        print("Language server stopped.")
    }
}

// Extension for reading lines from a FileHandle
extension FileHandle {
    func readLine() -> Data? {
        var lineData = Data()
        while let byte = readData(ofLength: 1).first {
            lineData.append(byte)
            if byte == UInt8(ascii: "\n") {
                return lineData
            }
        }
        return lineData.isEmpty ? nil : lineData
    }
}

#Preview {
    ContentView()
        .frame(width: 600, height: 600)
}
