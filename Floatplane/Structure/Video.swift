//
//  Video.swift
//  Floatplane
//
//  Created by Jack Perry on 30/9/18.
//  Copyright © 2018 Yoshimi Robotics. All rights reserved.
//

import Foundation

public struct Video: Decodable {
    /// Title
    public internal(set) var title: String

    /// GUID (Used for CDN)
    public internal(set) var guid: String

    /// Description
    public internal(set) var description: String

    /// Has the video been marked as private?
    public internal(set) var `private`: Bool

    /// Release date
    public internal(set) var releaseDate: Date

    /// Duration
    public internal(set) var duration: Double

    /// Creator UUID
    public internal(set) var creator: String

    /// Thumbnail image URL
    public internal(set) var thumbnailUrl: String
}
