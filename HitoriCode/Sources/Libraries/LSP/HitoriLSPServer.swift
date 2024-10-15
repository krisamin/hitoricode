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
//  Created : 10/15/24
//  Package : HitoriCode
//  File    : HitoriLSPServer.swift
//

import Foundation

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

enum HitoriLSPServerConnectionType {
    case stdio
    case tcp
}

class HitoriLSPServer {
    private let connectionType: HitoriLSPServerConnectionType

    private let serverPath: String
    private var process: Process?

    private var inputPipe: Pipe?
    private var outputPipe: Pipe?
    private var errorPipe: Pipe?

    private var responseBuffer = Data()

    var processId: Int32?

    init(connectionType: HitoriLSPServerConnectionType, serverPath: String) {
        self.connectionType = connectionType
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
        return header
            .components(separatedBy: "\r\n")
            .first(where: { $0.lowercased().starts(with: "content-length:") })
            .flatMap { Int($0.split(separator: ":")[1].trimmingCharacters(in: .whitespaces)) }
    }

    func stopServer() {
        process?.terminate()
        print("Language server stopped.")
    }
}
