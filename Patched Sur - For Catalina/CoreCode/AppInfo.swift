//
//  AppInfo.swift
//  Patched Sur - For Catalina
//
//  Created by Ben Sova on 6/20/23.
//

import Foundation

class AppInfo {
    static let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    static let build = Int(Bundle.main.infoDictionary!["CFBundleVersion"] as! String)!
    static let patchesV = { () -> PSPatchV in
        guard let patches = try? JSONDecoder().decode([PSPatchV].self, from: .init(contentsOf: URL(string: "https://ben216k.github.io/patched-sur/patches.json")!)) else {
            return .init(version: "v1.1.0", compatible: 123, url: "https://codeload.github.com/Ben216k/Patched-Sur-Patches/zip/9ee2b51", updateLog: "")
        }
        let patche = patches.filter { $0.compatible <= Int(Bundle.main.infoDictionary!["CFBundleVersion"] as! String)! }.last!
        return patche
    }()
    static func localKey(_ key: String, def: String? = nil) -> String {
        NSLocalizedString(key, comment: def ?? key).description
    }

}

struct PSPatchV: Codable {
    let version: String
    let compatible: Int
    let url: String
    let updateLog: String?

    enum CodingKeys: String, CodingKey {
        case version = "Version"
        case compatible = "Compatible"
        case url = "URL"
        case updateLog = "UpdateLog"
    }
}
