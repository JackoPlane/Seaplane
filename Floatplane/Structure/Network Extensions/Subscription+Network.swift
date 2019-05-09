//
//  Subscription+Network.swift
//  Floatplane
//
//  Created by Jack Perry on 30/9/18.
//  Copyright © 2018 Yoshimi Robotics. All rights reserved.
//

import Cache
import Alamofire
import Foundation

public typealias Subscriptions = [Subscription]

public extension Sequence where Iterator.Element == Subscription {
    
    static func load(_ completion: ((Subscriptions?) -> Void)? = nil) {
        Account.current()?.fetchSubscriptions({ (result) in
            completion?( try? result.get() )
        })
    }

}
