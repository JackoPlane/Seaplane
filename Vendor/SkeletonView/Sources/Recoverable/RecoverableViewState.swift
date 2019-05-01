//
//  RecoverableViewState.swift
//  SkeletonView
//
//  Created by Juanpe Catalán on 13/05/2018.
//  Copyright © 2018 SkeletonView. All rights reserved.
//

import UIKit

struct RecoverableViewState {
    var backgroundColor: UIColor?
    var cornerRadius: CGFloat
    var clipToBounds: Bool

    // UI text
    var text: String?

    // UI image
    var image: UIImage?
}

extension RecoverableViewState {
    init(view: UIView) {
        backgroundColor = view.backgroundColor
        clipToBounds = view.layer.masksToBounds
        cornerRadius = view.layer.cornerRadius
    }
}
