// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let patchedVersions = try PatchedVersions(json)

import Foundation

// MARK: - PatchedVersion
struct PatchedVersion: Codable {
    let url, assetsURL: String
    let uploadURL: String
    let htmlURL: String
    let id: Int
    let author: Author
    var nodeID, tagName, targetCommitish, name: String
    let draft, prerelease: Bool
    let createdAt, publishedAt: Date
    let assets: [Asset]
    let tarballURL, zipballURL: String
    let body: String

    enum CodingKeys: String, CodingKey {
        case url
        case assetsURL = "assets_url"
        case uploadURL = "upload_url"
        case htmlURL = "html_url"
        case id, author
        case nodeID = "node_id"
        case tagName = "tag_name"
        case targetCommitish = "target_commitish"
        case name, draft, prerelease
        case createdAt = "created_at"
        case publishedAt = "published_at"
        case assets
        case tarballURL = "tarball_url"
        case zipballURL = "zipball_url"
        case body
    }
}

// MARK: PatchedVersion convenience initializers and mutators

extension PatchedVersion {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(PatchedVersion.self, from: data)
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
        url: String? = nil,
        assetsURL: String? = nil,
        uploadURL: String? = nil,
        htmlURL: String? = nil,
        id: Int? = nil,
        author: Author? = nil,
        nodeID: String? = nil,
        tagName: String? = nil,
        targetCommitish: String? = nil,
        name: String? = nil,
        draft: Bool? = nil,
        prerelease: Bool? = nil,
        createdAt: Date? = nil,
        publishedAt: Date? = nil,
        assets: [Asset]? = nil,
        tarballURL: String? = nil,
        zipballURL: String? = nil,
        body: String? = nil
    ) -> PatchedVersion {
        return PatchedVersion(
            url: url ?? self.url,
            assetsURL: assetsURL ?? self.assetsURL,
            uploadURL: uploadURL ?? self.uploadURL,
            htmlURL: htmlURL ?? self.htmlURL,
            id: id ?? self.id,
            author: author ?? self.author,
            nodeID: nodeID ?? self.nodeID,
            tagName: tagName ?? self.tagName,
            targetCommitish: targetCommitish ?? self.targetCommitish,
            name: name ?? self.name,
            draft: draft ?? self.draft,
            prerelease: prerelease ?? self.prerelease,
            createdAt: createdAt ?? self.createdAt,
            publishedAt: publishedAt ?? self.publishedAt,
            assets: assets ?? self.assets,
            tarballURL: tarballURL ?? self.tarballURL,
            zipballURL: zipballURL ?? self.zipballURL,
            body: body ?? self.body
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Asset
struct Asset: Codable {
    let url: String
    let id: Int
    let nodeID, name: String
    let label: JSONNull?
    let uploader: Author
    let contentType, state: String
    let size, downloadCount: Int
    let createdAt, updatedAt: Date
    let browserDownloadURL: String

    enum CodingKeys: String, CodingKey {
        case url, id
        case nodeID = "node_id"
        case name, label, uploader
        case contentType = "content_type"
        case state, size
        case downloadCount = "download_count"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case browserDownloadURL = "browser_download_url"
    }
}

// MARK: Asset convenience initializers and mutators

extension Asset {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Asset.self, from: data)
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
        url: String? = nil,
        id: Int? = nil,
        nodeID: String? = nil,
        name: String? = nil,
        label: JSONNull?? = nil,
        uploader: Author? = nil,
        contentType: String? = nil,
        state: String? = nil,
        size: Int? = nil,
        downloadCount: Int? = nil,
        createdAt: Date? = nil,
        updatedAt: Date? = nil,
        browserDownloadURL: String? = nil
    ) -> Asset {
        return Asset(
            url: url ?? self.url,
            id: id ?? self.id,
            nodeID: nodeID ?? self.nodeID,
            name: name ?? self.name,
            label: label ?? self.label,
            uploader: uploader ?? self.uploader,
            contentType: contentType ?? self.contentType,
            state: state ?? self.state,
            size: size ?? self.size,
            downloadCount: downloadCount ?? self.downloadCount,
            createdAt: createdAt ?? self.createdAt,
            updatedAt: updatedAt ?? self.updatedAt,
            browserDownloadURL: browserDownloadURL ?? self.browserDownloadURL
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Author
struct Author: Codable {
    let login: String
    let id: Int
    let nodeID: String
    let avatarURL: String
    let gravatarID: String
    let url, htmlURL, followersURL: String
    let followingURL, gistsURL, starredURL: String
    let subscriptionsURL, organizationsURL, reposURL: String
    let eventsURL: String
    let receivedEventsURL: String
    let type: String
    let siteAdmin: Bool

    enum CodingKeys: String, CodingKey {
        case login, id
        case nodeID = "node_id"
        case avatarURL = "avatar_url"
        case gravatarID = "gravatar_id"
        case url
        case htmlURL = "html_url"
        case followersURL = "followers_url"
        case followingURL = "following_url"
        case gistsURL = "gists_url"
        case starredURL = "starred_url"
        case subscriptionsURL = "subscriptions_url"
        case organizationsURL = "organizations_url"
        case reposURL = "repos_url"
        case eventsURL = "events_url"
        case receivedEventsURL = "received_events_url"
        case type
        case siteAdmin = "site_admin"
    }
}

// MARK: Author convenience initializers and mutators

extension Author {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Author.self, from: data)
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
        login: String? = nil,
        id: Int? = nil,
        nodeID: String? = nil,
        avatarURL: String? = nil,
        gravatarID: String? = nil,
        url: String? = nil,
        htmlURL: String? = nil,
        followersURL: String? = nil,
        followingURL: String? = nil,
        gistsURL: String? = nil,
        starredURL: String? = nil,
        subscriptionsURL: String? = nil,
        organizationsURL: String? = nil,
        reposURL: String? = nil,
        eventsURL: String? = nil,
        receivedEventsURL: String? = nil,
        type: String? = nil,
        siteAdmin: Bool? = nil
    ) -> Author {
        return Author(
            login: login ?? self.login,
            id: id ?? self.id,
            nodeID: nodeID ?? self.nodeID,
            avatarURL: avatarURL ?? self.avatarURL,
            gravatarID: gravatarID ?? self.gravatarID,
            url: url ?? self.url,
            htmlURL: htmlURL ?? self.htmlURL,
            followersURL: followersURL ?? self.followersURL,
            followingURL: followingURL ?? self.followingURL,
            gistsURL: gistsURL ?? self.gistsURL,
            starredURL: starredURL ?? self.starredURL,
            subscriptionsURL: subscriptionsURL ?? self.subscriptionsURL,
            organizationsURL: organizationsURL ?? self.organizationsURL,
            reposURL: reposURL ?? self.reposURL,
            eventsURL: eventsURL ?? self.eventsURL,
            receivedEventsURL: receivedEventsURL ?? self.receivedEventsURL,
            type: type ?? self.type,
            siteAdmin: siteAdmin ?? self.siteAdmin
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

typealias PatchedVersions = [PatchedVersion]

extension Array where Element == PatchedVersions.Element {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(PatchedVersions.self, from: data)
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

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }
    
    func hash(into hasher: inout Hasher) {
        0.hash(into: &hasher)
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
