//
//  Account.swift
//  Floatplane
//
//  Created by Jack Perry on 18/9/18.
//  Copyright © 2018 Yoshimi Robotics. All rights reserved.
//

import Cache
import Alamofire
import Foundation

public struct Account: Codable, Equatable {
    
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

    /// Subscriptions
    public internal(set) var subscriptions: Subscriptions?
    
    
    // Cache
    internal static let cache: AccountCache = AccountCache()


    // MARK: Current user
    // ------------------------------------------------------------------------------

    public static func current() -> Account?
    {
        return try? Account.cache.storage?.object(forKey: "current")
    }
    
    
    // MARK: Comparable
    // ------------------------------------------------------------------------------
    
    public static func == (lhs: Account, rhs: Account) -> Bool
    {
        return lhs.identifier == rhs.identifier
    }
    
    
    
    // MARK: Authentication events
    // ------------------------------------------------------------------------------
    
    public static func login(username: String, password: String, _ completion: @escaping (Swift.Result<Account, Error>) -> Void)
    {
        let url = "https://www.floatplane.com/api/auth/login"
        let parameters: Parameters = ["username": username, "password": password]
        
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .printCurl()
            .responseDecodable { (response: DataResponse<Account>) in
                if let account = response.value {
                    let cookies = HTTPCookieStorage.shared.cookies ?? []
                    let token = cookies.filter { $0.name == "sails.sid" }.first!
                    
                    // Save SailsJS SID for future requests (auth cookie)
                    UserDefaults.standard.set(token.value, forKey: "sails.sid")
                    
                    // Store the Account in the in-memory cache for `.current()` lookups
                    try? Account.cache.storage?.setObject(account, forKey: "current")
                    
                    completion(.success(account))
                } else if let error = response.error {
                    completion(.failure(error))
                }
                
            }
        
    }

    public func logout() {}
}



internal struct AccountCache {
    
    var storage: Storage<Account>?
    
    init() {
        let diskConfig = DiskConfig(name: "", expiry: .seconds(1), maxSize: 1)
        let memoryConfig = MemoryConfig(expiry: .never, countLimit: 1, totalCostLimit: 1000)
        
        // Setup the storage engine..
        storage = try? Storage(diskConfig: diskConfig, memoryConfig: memoryConfig, transformer: TransformerFactory.forCodable(ofType: Account.self))
    }
}
