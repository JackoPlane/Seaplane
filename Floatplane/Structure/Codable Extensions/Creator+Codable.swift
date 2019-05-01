//
//  Creator+Codable.swift
//  Floatplane
//
//  Created by Jack Perry on 30/9/18.
//  Copyright © 2018 Yoshimi Robotics. All rights reserved.
//

import Foundation

public extension Creator {
    // MARK: - Coding Keys

    // ------------------------------------------------------------------------------

    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case title
        case description
        case about
        case owner
        case icon
        case created = "createdAt"
        case updated = "updatedAt"
    }

    // MARK: - Codable

    // ------------------------------------------------------------------------------

    init(from decoder: Decoder) throws {
        // Extract the top-level values ("user")
        let values = try decoder.container(keyedBy: CodingKeys.self)

        identifier = try values.decode(String.self, forKey: .identifier)
        title = try values.decode(String.self, forKey: .title)
        description = try values.decode(String.self, forKey: .description)
        about = try values.decode(String.self, forKey: .about)
        owner = try values.decode(Creator.Profile.self, forKey: .owner)
        icon = try values.decode(Creator.Icon.self, forKey: .icon)
        created = try? values.decode(Date.self, forKey: .created)
        updated = try? values.decode(Date.self, forKey: .updated)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(identifier, forKey: .identifier)
        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        try container.encode(about, forKey: .about)
        try container.encode(owner, forKey: .owner)
        try container.encode(icon, forKey: .icon)
        try container.encode(created, forKey: .created)
        try container.encode(updated, forKey: .updated)
    }
}

public extension Creator.Icon {
    // MARK: - Coding Keys

    // ------------------------------------------------------------------------------

    enum CodingKeys: String, CodingKey {
        case path
        case width
        case height
    }

    // MARK: - Codable

    // ------------------------------------------------------------------------------

    init(from decoder: Decoder) throws {
        // Extract the top-level values ("user")
        let values = try decoder.container(keyedBy: CodingKeys.self)

        path = try values.decode(String.self, forKey: .path)
        width = try values.decode(Double.self, forKey: .width)
        height = try values.decode(Double.self, forKey: .height)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(path, forKey: .path)
        try container.encode(width, forKey: .width)
        try container.encode(height, forKey: .height)
    }
}

public extension Creator.Profile {
    // MARK: - Coding Keys

    // ------------------------------------------------------------------------------

    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case username
        case profileImage
    }

    enum ProfileImageKeys: String, CodingKey {
        case path
        case width
        case height
    }

    // MARK: - Codable

    // ------------------------------------------------------------------------------

    init(from decoder: Decoder) throws {
        // Extract the top-level values ("user")
        let values = try decoder.container(keyedBy: CodingKeys.self)

        identifier = try values.decode(String.self, forKey: .identifier)
        username = try values.decode(String.self, forKey: .username)

        // Profile image
        let profileImageValues = try? values.nestedContainer(keyedBy: ProfileImageKeys.self, forKey: .profileImage)
        if let profileImageValues = profileImageValues {
            profileImage = try profileImageValues.decode(String.self, forKey: .path)
        } else {
            profileImage = nil
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(identifier, forKey: .identifier)
        try container.encode(username, forKey: .username)
        try container.encode(["path": profileImage], forKey: .profileImage)
    }
}
