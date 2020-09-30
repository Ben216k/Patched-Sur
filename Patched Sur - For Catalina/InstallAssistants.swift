//
//  InstallAssistants.swift
//  Patched Sur - For Catalina
//
//  Created by Benjamin Sova on 9/29/20.
//

import Foundation

extension URL: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self = URL(string: value)!
    }
}

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let installAssistants = try InstallAssistants(json)

// MARK: - InstallAssistant
struct InstallAssistant: Codable {
    var url: URL
    var date, buildNumber, version: String
    var minVersion, orderNumber: Int

    enum CodingKeys: String, CodingKey {
        case url = "URL"
        case date = "Date"
        case buildNumber = "BuildNumber"
        case version = "Version"
        case minVersion = "MinVersion"
        case orderNumber = "OrderNumber"
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

    func with(
        url: URL? = nil,
        date: String? = nil,
        buildNumber: String? = nil,
        version: String? = nil,
        minVersion: Int? = nil,
        orderNumber: Int? = nil
    ) -> InstallAssistant {
        return InstallAssistant(
            url: url ?? self.url,
            date: date ?? self.date,
            buildNumber: buildNumber ?? self.buildNumber,
            version: version ?? self.version,
            minVersion: minVersion ?? self.minVersion,
            orderNumber: orderNumber ?? self.orderNumber
        )
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
