//
//  LandscapeAVPlayerController.swift
//  Floatplane
//
//  Created by Jack Perry on 1/10/18.
//  Copyright © 2018 Yoshimi Robotics. All rights reserved.
//

import AVKit
import Foundation

class LandscapeAVPlayerController: AVPlayerViewController {
    #if os(iOS)
        override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
            return .landscape
        }
    #endif
}
