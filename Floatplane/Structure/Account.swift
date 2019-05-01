//
//  Account.swift
//  Floatplane
//
//  Created by Jack Perry on 18/9/18.
//  Copyright © 2018 Yoshimi Robotics. All rights reserved.
//

import Alamofire
import Foundation

public struct Account: Codable {
    /// Account Identifier
    public internal(set) var identifier: String

    /// Username
    public internal(set) var username: String

    /// Profile image URL
    public internal(set) var profileImage: String

    /// Email address
    public internal(set) var emailAddress: String?

    /// Display name
    public internal(set) var displayName: String?

    // MARK: Authentication events

    // ------------------------------------------------------------------------------

    public static func login(username: String, password: String, _ completion: ((Bool, Error?) -> Void)?) {
        let url = "https://www.floatplane.com/api/auth/login"
        let parameters: Parameters = ["username": username, "password": password]
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .printCurl()
            .responseDecodable { (result: DataResponse<Account>) in

                if let _ = result.value {
                    let cookies = HTTPCookieStorage.shared.cookies ?? []
                    let token = cookies.filter { $0.name == "sails.sid" }.first!

                    UserDefaults.standard.set(token.value, forKey: "sails.sid")

                    completion?(true, nil)
                } else {
                    completion?(false, nil)
                }
            }
    }

    public func logout() {}
}
