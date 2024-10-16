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
//  File    : HitoriFileManager.swift
//

import Foundation

enum HitoriFileType {
    case file
    case directory
}

struct HitoriFileItem {
    /// file type (file or directory)
    let type: HitoriFileType
    /// full path
    let path: String
    /// file name (ex: README.md) - if directory, it's directory name
    let name: String
    /// file extension (ex: txt, ts, tsx, swift) - nil if directory
    let ext: String?
}

class HitoriFileManager {
    static let shared = HitoriFileManager()

    static func getAppSupportDir() -> String {
        var appSupportDir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let bundleId = Bundle.main.bundleIdentifier

        if bundleId == nil {
            print("[HitoriFileManager] Error: Bundle Identifier is nil")
            return ""
        }

        appSupportDir.appendPathComponent(bundleId!)

        if !FileManager.default.fileExists(atPath: appSupportDir.path) {
            do {
                try FileManager.default
                    .createDirectory(at: appSupportDir, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("[HitoriFileManager] Error: \(error.localizedDescription)")
            }
        }

        return appSupportDir.path
    }

    static func getDirectoryItems(path: String) -> [HitoriFileItem] {
        var items: [HitoriFileItem] = []
        let fileManager = FileManager.default
        let url = URL(fileURLWithPath: path)
        do {
            let contents = try fileManager.contentsOfDirectory(
                at: url,
                includingPropertiesForKeys: nil,
                options: .skipsHiddenFiles
            )

            for item in contents {
                let type: HitoriFileType = item.hasDirectoryPath ? .directory : .file
                let name = item.lastPathComponent
                let ext = item.pathExtension
                items.append(HitoriFileItem(type: type, path: item.path, name: name, ext: ext))
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        return items
    }
}
