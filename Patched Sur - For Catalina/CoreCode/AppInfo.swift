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
