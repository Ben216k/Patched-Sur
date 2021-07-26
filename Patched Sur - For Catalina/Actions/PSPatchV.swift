// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let pSPatchVs = try PSPatchVs(json)

import Foundation

// MARK: - PSPatchV
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

// MARK: PSPatchV convenience initializers and mutators

extension PSPatchV {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(PSPatchV.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

typealias PSPatchVs = [PSPatchV]

extension Array where Element == PSPatchVs.Element {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(PSPatchVs.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
