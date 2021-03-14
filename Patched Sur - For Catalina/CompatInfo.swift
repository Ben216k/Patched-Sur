// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let compatInfo = try CompatInfo(json)

import Foundation

// MARK: - CompatInfo
struct CompatInfo: Codable {
    let macName, author: String
    let approved: [String]
    let details: String
    let works, unknown, warns: [String]

    enum CodingKeys: String, CodingKey {
        case macName = "MacName"
        case author = "Author"
        case approved = "Approved"
        case details = "Details"
        case works = "Works"
        case unknown = "Unknown"
        case warns = "Warns"
    }
}

// MARK: CompatInfo convenience initializers and mutators

extension CompatInfo {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(CompatInfo.self, from: data)
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
