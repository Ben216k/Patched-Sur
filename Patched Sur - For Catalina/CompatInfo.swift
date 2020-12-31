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

struct ProblemInfoElement: Codable {
    let title, problemInfoDescription, type, check: String

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case problemInfoDescription = "Description"
        case type = "Type"
        case check = "Check"
    }
}

// MARK: ProblemInfoElement convenience initializers and mutators

extension ProblemInfoElement {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ProblemInfoElement.self, from: data)
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

    func with(
        title: String? = nil,
        problemInfoDescription: String? = nil,
        type: String? = nil,
        check: String? = nil
    ) -> ProblemInfoElement {
        return ProblemInfoElement(
            title: title ?? self.title,
            problemInfoDescription: problemInfoDescription ?? self.problemInfoDescription,
            type: type ?? self.type,
            check: check ?? self.check
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

typealias ProblemInfo = [ProblemInfoElement]

extension Array where Element == ProblemInfo.Element {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ProblemInfo.self, from: data)
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
