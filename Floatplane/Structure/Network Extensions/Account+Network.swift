//
//  Account+Network.swift
//  Floatplane
//
//  Created by Jack Perry on 7/5/19.
//  Copyright © 2019 Yoshimi Robotics. All rights reserved.
//

import Foundation
import Alamofire

public extension Account
{
    
    func fetchExtendedAttributes(_ completion: ((Swift.Result<Account, Error>) -> Void)? = nil)
    {
        var url: URLConvertible = "https://www.floatplane.com/api/user/named"
        var parameters: Parameters? = ["username": username]
        
        // If we're attempting to load our own details, hit the `/self` endpoint
        if let current = Account.current(), self == current {
            url = "https://www.floatplane.com/api/user/self"
            parameters = nil
        }
        
        
        AF.request(url, method: .get, parameters: parameters)
        .printCurl()
        .responseDecodable(completionHandler: { (response: DataResponse<Account>) in
            print("Loaded extended atributes: \(response.value)")
        })
    }
    
    
    func fetchSubscriptions(_ completion: @escaping ((Swift.Result<Subscriptions, Error>) -> Void))
    {
        let url = "https://www.floatplane.com/api/user/subscriptions"
        
        AF.request(url, method: .get)
            .printCurl()
            .responseDecodable(completionHandler: { (response: DataResponse<Subscriptions>) in
                
                switch response.result {
                    case .success(let subscriptions):
                        var account = self
                        account.subscriptions = subscriptions
                        try? Account.cache.storage?.setObject(account, forKey: "current")

                    case .failure(_):
                        break
                }
                
                completion(response.result)
            })
    }
    
}
