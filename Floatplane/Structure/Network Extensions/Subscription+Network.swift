//
//  Subscription+Network.swift
//  Floatplane
//
//  Created by Jack Perry on 30/9/18.
//  Copyright © 2018 Yoshimi Robotics. All rights reserved.
//

import Alamofire
import Foundation

public typealias Subscriptions = [Subscription]

public extension Sequence where Iterator.Element == Subscription {
    static func load(_ completion: ((Subscriptions?) -> Void)? = nil) {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.iso8601Full)

        let url = "https://www.floatplane.com/api/user/subscriptions"
        AF.request(url, method: .get)
            .printCurl()
            .responseJSON(completionHandler: { response in
                print("[SUBSCRIPTIONS][JSON] \(response.value)")
            })
            .responseDecodable(decoder: decoder, completionHandler: { (result: DataResponse<Subscriptions>) in
                completion?(result.value)
            })
    }
}
