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
//  Created : 10/16/24
//  Package : HitoriCode
//  File    : LSPInitialize.swift
//

class LSPInitializeParams: BaseParams {
    struct ClientCapabilities: Codable {
        let engine: String
        let version: String?
    }

    let processId: Int
    let rootUri: String
    let capabilities: ClientCapabilities

    init(processId: Int, rootUri: String, capabilities: ClientCapabilities) {
        self.processId = processId
        self.rootUri = rootUri
        self.capabilities = capabilities
    }
}

class LSPInitializeRequest: HitoriLSPMessage {
    typealias Params = LSPInitializeParams

    let jsonrpc: String
    let id: Int
    let method: String
    let params: LSPInitializeParams

    init(id: Int, processId: Int, rootUri: String, capabilities: LSPInitializeParams.ClientCapabilities?) {
        let cap: LSPInitializeParams.ClientCapabilities = if capabilities == nil {
            LSPInitializeParams.ClientCapabilities(engine: "ECMAScript", version: "ES2020")
        } else {
            capabilities!
        }

        self.jsonrpc = "2.0"
        self.id = id
        self.method = "initialize"
        self.params = LSPInitializeParams(processId: processId, rootUri: rootUri, capabilities: cap)
    }
}
