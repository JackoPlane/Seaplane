//
//  Subscription+Codable.swift
//  Floatplane
//
//  Created by Jack Perry on 30/9/18.
//  Copyright © 2018 Yoshimi Robotics. All rights reserved.
//

import Foundation

public extension Subscription {
    // MARK: - Coding Keys

    // ------------------------------------------------------------------------------

    enum CodingKeys: String, CodingKey {
        case creator
        case startDate
        case endDate
        case paymentIdentifier = "paymentID"
        case paymentCancelled
        case plan
    }

    // MARK: - Decoding

    // ------------------------------------------------------------------------------

    init(from decoder: Decoder) throws {
        // Extract the top-level values ("user")
        let values = try decoder.container(keyedBy: CodingKeys.self)

        // Extract each property from the nested container
        creator = try values.decode(String.self, forKey: .creator)
        startDate = try? values.decode(Date.self, forKey: .startDate)
        endDate = try? values.decode(Date.self, forKey: .endDate)
        plan = try? values.decode(Plan.self, forKey: .plan)
    }
}

public extension Subscription.Plan {
    // MARK: - Coding Keys

    // ------------------------------------------------------------------------------

    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case title
        case description
        case price
        case currency
        case interval
        case intervalCount
        case logo
    }
}
