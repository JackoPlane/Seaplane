//
//  Creator+Network.swift
//  Floatplane
//
//  Created by Jack Perry on 30/9/18.
//  Copyright © 2018 Yoshimi Robotics. All rights reserved.
//

import Alamofire
import Cache
import Foundation

internal struct CreatorCache {
    var storage: Storage<Creator>?

    init() {
        let diskConfig = DiskConfig(name: "Creators")
        let memoryConfig = MemoryConfig(expiry: .never, countLimit: 10, totalCostLimit: 10)

        // Setup the storage engine..
        storage = try? Storage(diskConfig: diskConfig, memoryConfig: memoryConfig, transformer: TransformerFactory.forCodable(ofType: Creator.self))
    }
}

public extension Creator {
    static func load(_ completion: (([Creator]?) -> Void)? = nil) {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.iso8601Full)

        let url = "https://www.floatplane.com/api/creator/list"
        AF.request(url, method: .get)
            .printCurl()
            .responseDecodable(decoder: decoder, completionHandler: { (result: DataResponse<[Creator]>) in

                defer { completion?(result.value) }

                let creators = result.value?.compactMap { $0 } ?? []
                creators.forEach {
                    // Save creator to the cache..
                    ((try? Creator.cache.storage?.setObject($0, forKey: $0.identifier)) as ()??)
                }

            })
    }

    static func find(identifier: String) -> Creator? {
        do {
            return (try Creator.cache.storage?.object(forKey: identifier))
        } catch {
            return nil
        }
    }
}
