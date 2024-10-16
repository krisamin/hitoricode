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
//  File    : HitoriLSPMessage.swift
//

import Foundation

protocol BaseParams: Codable {}

protocol HitoriLSPMessage: Codable {
    associatedtype Params: BaseParams

    var jsonrpc: String { get }
    var id: Int { get }
    var method: String { get }
    var params: Params { get }

    func buildJson(prettyPrinted: Bool) -> String
    func createRequest() -> String
}

extension HitoriLSPMessage {
    func buildJson(prettyPrinted: Bool = false) -> String {
        let encoder = JSONEncoder()

        // 설정된 옵션에 따라 출력 포맷팅을 적용
        if prettyPrinted {
            encoder.outputFormatting = .prettyPrinted
        }

        do {
            let jsonData = try encoder.encode(self)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            } else {
                return "{}"
            }
        } catch {
            print("Error encoding JSON: \(error)")
            return "{}"
        }
    }

    func createRequest() -> String {
        let json = buildJson()

        let header = "Content-Length: \(json.utf8.count)\r\n\r\n"

        let request = header + json

        print("[HitoriLSPMessage] Created Request: \(request)")

        return request
    }
}
