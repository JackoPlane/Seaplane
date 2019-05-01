//
//  Video+Network.swift
//  Floatplane
//
//  Created by Jack Perry on 30/9/18.
//  Copyright © 2018 Yoshimi Robotics. All rights reserved.
//

import Alamofire
import Foundation

public typealias Videos = [Video]

public extension Sequence where Iterator.Element == Video {
    static func load(creator: String, limit: Int = 10, skip: Int? = nil, _ completion: ((Videos?) -> Void)? = nil) {
        var parameters: Parameters = ["creatorGUID": creator, "limit": limit]
        if let skip = skip {
            parameters["fetchAfter"] = skip
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.iso8601Full)

        let url = "https://www.floatplane.com/api/creator/videos"
        AF.request(url, method: .get, parameters: parameters)
            .printCurl()
            .responseDecodable(decoder: decoder, completionHandler: { (result: DataResponse<Videos>) in
                completion?(result.value)
            })
    }

    static func load(creators: [String], limit: Int = 20, skip: Int? = nil, _ completion: ((Videos?) -> Void)? = nil) {
        var videos: Videos = []

        let dispatchGroup = DispatchGroup()
        creators.forEach {
            dispatchGroup.enter()
            Videos.load(creator: $0, limit: limit, skip: skip) { response in
                defer { dispatchGroup.leave() }

                // Append videos
                videos.append(contentsOf: response?.compactMap { $0 } ?? [])
            }
        }

        // Upon completion..
        dispatchGroup.notify(queue: .main) {
            // DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            completion?(videos)
            // })
        }
    }
}

public extension Video {
    func getURL(_ completion: ((String?) -> Void)? = nil) {
        let parameters: Parameters = ["guid": guid, "quality": "1080"]
        let url = "https://www.floatplane.com/api/video/url"
        AF.request(url, method: .get, parameters: parameters)
            .printCurl()
            .responseJSON(completionHandler: { response in
                completion?(response.result.value as? String)
            })
    }
}
