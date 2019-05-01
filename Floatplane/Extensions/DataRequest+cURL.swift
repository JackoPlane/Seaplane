//
//  DataRequest+cURL.swift
//  Floatplane
//
//  Created by Jack Perry on 18/4/19.
//  Copyright © 2019 Yoshimi Robotics. All rights reserved.
//

import Alamofire
import Foundation

public extension DataRequest {
    func printCurl() -> DataRequest {
        debugPrint(self)

        return self
    }
}
