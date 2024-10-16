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
//  File    : HitoriRuntimeManager.swift
//

import Foundation

enum RuntimeArchiteture: String, Codable {
    case amd64 = "x86_64"
    case aarch64 = "arm64"
}

enum RemoteRuntime {
    // swiftlint:disable identifier_name
    case nodejs_18_aarch64
    case nodejs_18_aarch64_suck
    // swiftlint:enable identifier_name

    var runtime: HitoriRuntime {
        switch self {
        case .nodejs_18_aarch64:
            HitoriRuntime(
                name: "nodejs",
                version: "v18.10.0",
                architecture: .aarch64,
                origin: "https://nodejs.org/dist/v18.10.0/node-v18.10.0-linux-arm",
                path: nil
            )
        default:
            "" as! HitoriRuntime
        }
    }
}

struct HitoriRuntime: Codable {
    let name: String
    let version: String
    let architecture: RuntimeArchiteture
    let origin: String?
    let path: String?
}

class HitoriRuntimeManager {
    static let shared = HitoriRuntimeManager()

    public struct RuntimeConfig: Codable {
        var runtimes: [HitoriRuntime]
    }

    private var config = RuntimeConfig(runtimes: [])

    private var configFilePath: String {
        HitoriRuntimeManager.getRuntimePath() + "/config.json"
    }

    init() {
        readConfigFile()
    }

    private func isConfigFileAvailable() -> Bool {
        FileManager.default.fileExists(atPath: configFilePath)
    }

    public func readConfigFile() {
        do {
            if isConfigFileAvailable() {
                let data = try Data(contentsOf: URL(fileURLWithPath: configFilePath))
                config = try JSONDecoder().decode(RuntimeConfig.self, from: data)
                print("read config")
            } else {
                writeConfigFile()
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }

    public func writeConfigFile() {
        do {
            if !isConfigFileAvailable() {
                FileManager.default.createFile(atPath: configFilePath, contents: nil, attributes: nil)
            }

            let data = try JSONEncoder().encode(config)
            try data.write(to: URL(fileURLWithPath: configFilePath))
            print("write config")
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }

    public static func getRuntimePath() -> String {
        let runtimePath = HitoriFileManager.getAppSupportDir() + "/runtimes"
        if !FileManager.default.fileExists(atPath: runtimePath) {
            do {
                try FileManager.default
                    .createDirectory(atPath: runtimePath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("[HitoriRuntimeManager] Error: \(error.localizedDescription)")
            }
        }

        return runtimePath
    }

    public func hasRuntime(name: String, version: String, architecture: RuntimeArchiteture) -> Bool {
        let runtime = config.runtimes.first {
            $0.name == name && $0.version == version && $0.architecture == architecture
        }

        return runtime != nil
    }
}
