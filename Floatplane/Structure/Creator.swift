//
//  Creator.swift
//  Floatplane
//
//  Created by Jack Perry on 30/9/18.
//  Copyright © 2018 Yoshimi Robotics. All rights reserved.
//

import Foundation

public struct Creator: Codable {
    /// Object cache
    internal static let cache: CreatorCache = CreatorCache()

    /// Identifier
    public internal(set) var identifier: String

    /// Title / "Display name"
    public internal(set) var title: String

    /// Creation description
    public internal(set) var description: String

    /// About creator
    public internal(set) var about: String

    /// Icon
    public internal(set) var icon: Creator.Icon?

    /// Owner
    public internal(set) var owner: Creator.Profile?

    /// Created at
    public internal(set) var created: Date?

    /// Updated at
    public internal(set) var updated: Date?

    public struct Profile: Codable {
        /// Identifier
        public internal(set) var identifier: String

        /// Usernmae
        public internal(set) var username: String

        /// Profile image
        public internal(set) var profileImage: String?
    }

    public struct Icon: Codable {
        /// Icon width
        public internal(set) var width: Double

        /// Icon height
        public internal(set) var height: Double

        /// Icon image oath
        public internal(set) var path: String
    }
}
