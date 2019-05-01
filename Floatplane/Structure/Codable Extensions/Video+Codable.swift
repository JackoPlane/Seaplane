//
//  Video+Codable.swift
//  Floatplane
//
//  Created by Jack Perry on 30/9/18.
//  Copyright © 2018 Yoshimi Robotics. All rights reserved.
//

import Foundation

public extension Video {
    // MARK: - Coding Keys

    // ------------------------------------------------------------------------------

    enum CodingKeys: String, CodingKey {
        case title
        case guid
        case description
        case `private`
        case releaseDate
        case duration
        case creator
        case thumbnail
    }

    enum ThumbnailImageKeys: String, CodingKey {
        case path
        case width
        case height
    }

    // MARK: - Decoding

    // ------------------------------------------------------------------------------

    init(from decoder: Decoder) throws {
        // Extract the top-level values ("user")
        let values = try decoder.container(keyedBy: CodingKeys.self)

        // Extract each property from the nested container
        title = try values.decode(String.self, forKey: .title)
        guid = try values.decode(String.self, forKey: .guid)
        description = try values.decode(String.self, forKey: .description)
        `private` = try values.decode(Bool.self, forKey: .private)
        releaseDate = try values.decode(Date.self, forKey: .releaseDate)
        duration = try values.decode(Double.self, forKey: .duration)
        creator = try values.decode(String.self, forKey: .creator)

        // Thumbnail image
        let thumbnail = try values.nestedContainer(keyedBy: ThumbnailImageKeys.self, forKey: .thumbnail)
        thumbnailUrl = try thumbnail.decode(String.self, forKey: .path)
    }
}
