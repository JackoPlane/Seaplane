//
//  Account+Codable.swift
//  Floatplane
//
//  Created by Jack Perry on 30/9/18.
//  Copyright © 2018 Yoshimi Robotics. All rights reserved.
//

import Foundation

public extension Account {
    // MARK: - Coding Keys

    // ------------------------------------------------------------------------------

    enum CodingKeys: String, CodingKey {
        case user
    }

    enum AccountKeys: String, CodingKey {
        case identifier = "id"
        case username
        case displayName
        case emailAddress = "email"
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

        // Extract the user object as a nested container
        let account = try values.nestedContainer(keyedBy: AccountKeys.self, forKey: .user)

        // Extract each property from the nested container
        identifier = try account.decode(String.self, forKey: .identifier)
        username = try account.decode(String.self, forKey: .username)
        emailAddress = try? account.decode(String.self, forKey: .emailAddress)
        displayName = try? account.decode(String.self, forKey: .displayName)

        // Profile image
        let profileImageValues = try account.nestedContainer(keyedBy: ProfileImageKeys.self, forKey: .profileImage)
        profileImage = try profileImageValues.decode(String.self, forKey: .path)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: AccountKeys.self)

        try container.encode(identifier, forKey: .identifier)
        try container.encode(username, forKey: .username)
        try container.encode(emailAddress, forKey: .emailAddress)
    }
}
