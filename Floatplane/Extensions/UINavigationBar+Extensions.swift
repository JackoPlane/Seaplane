//
//  UINavigationBar+Extensions.swift
//  Floatplane
//
//  Created by Jack Perry on 30/9/18.
//  Copyright © 2018 Yoshimi Robotics. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationBar {
    func setupNavigationBar() {
        let titleImageWidth = frame.size.width * 0.32
        let titleImageHeight = frame.size.height * 0.64
        var navigationBarIconimageView = UIImageView()

        if #available(iOS 11.0, *) {
            navigationBarIconimageView.widthAnchor.constraint(equalToConstant: titleImageWidth).isActive = true
            navigationBarIconimageView.heightAnchor.constraint(equalToConstant: titleImageHeight).isActive = true
        } else {
            navigationBarIconimageView = UIImageView(frame: CGRect(x: 0, y: 0, width: titleImageWidth, height: titleImageHeight))
        }

        navigationBarIconimageView.contentMode = .scaleAspectFit
        navigationBarIconimageView.image = UIImage(named: "floatplane-logo")
        topItem?.titleView = navigationBarIconimageView
    }
}
