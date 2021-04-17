// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let installAssistants = try InstallAssistants(json)

import Foundation

// MARK: - InstallAssistant
struct InstallAssistant: Codable {
    let url: String
    let date, buildNumber, version: String
    let minVersion, orderNumber: Int
    let notes: String?

    enum CodingKeys: String, CodingKey {
        case url = "URL"
        case date = "Date"
        case buildNumber = "BuildNumber"
        case version = "Version"
        case minVersion = "MinVersion"
        case orderNumber = "OrderNumber"
        case notes = "Notes"
    }
}

// MARK: InstallAssistant convenience initializers and mutators

extension InstallAssistant {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(InstallAssistant.self, from: data)
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

typealias InstallAssistants = [InstallAssistant]

extension Array where Element == InstallAssistants.Element {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(InstallAssistants.self, from: data)
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

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}

extension URL: ExpressibleByStringInterpolation {
    public init(stringLiteral: String) {
        self.init(string: stringLiteral)!
    }
}


// MARK: - MicropatcherRequirementElement
struct MicropatcherRequirement: Codable {
    let version: String
    let patcher: Int
}

// MARK: MicropatcherRequirementElement convenience initializers and mutators

extension MicropatcherRequirement {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(MicropatcherRequirement.self, from: data)
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
        version: String? = nil,
        patcher: Int? = nil
    ) -> MicropatcherRequirement {
        return MicropatcherRequirement(
            version: version ?? self.version,
            patcher: patcher ?? self.patcher
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

typealias MicropatcherRequirements = [MicropatcherRequirement]

extension Array where Element == MicropatcherRequirements.Element {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(MicropatcherRequirements.self, from: data)
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
