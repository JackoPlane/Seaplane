//
//  User.swift
//  
//
//  Created by Jack Perry on 3/1/2023.
//

import Foundation

public struct User: Codable, Identifiable {

    public struct ProfileImage: Codable {
        public let width: Double
        public let height: Double
        public let path: URL
    }

    public let id: String
    public let username: String
    public let email: String
    public let displayName: String

    public let profileImage: ProfileImage
}
