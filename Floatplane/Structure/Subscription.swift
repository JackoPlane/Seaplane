//
//  Subscription.swift
//  Floatplane
//
//  Created by Jack Perry on 30/9/18.
//  Copyright © 2018 Yoshimi Robotics. All rights reserved.
//

import Foundation

public struct Subscription: Decodable {
    /// Creator identifier
    public internal(set) var creator: String

    /// Start date
    public internal(set) var startDate: Date?

    /// End date
    public internal(set) var endDate: Date?

    /// Plan
    public internal(set) var plan: Subscription.Plan?

    /// Subscription Plan
    public struct Plan: Decodable {
        /// Identifier
        var identifier: String

        /// Title
        var title: String

        /// Description
        var description: String

        /// Price
        var price: String

        /// Currency
        var currency: String

        /// Payment interval
        var interval: String

        /// Payment interval count
        var intervalCount: Int

        /// Logo
        var logo: String?
    }
}
