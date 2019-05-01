//
//  VideoCollectionViewCell.swift
//  Floatplane
//
//  Created by Jack Perry on 30/9/18.
//  Copyright © 2018 Yoshimi Robotics. All rights reserved.
//

import Foundation
import UIKit

public class VideoCollectionViewCell: UICollectionViewCell {
    /// Thumbnail image view
    @IBOutlet var thumbnailImageView: UIImageView?

    /// Title label
    @IBOutlet var titleLabel: UILabel?

    /// Creator image view
    @IBOutlet var creatorImageView: UIImageView?

    /// Creator title label
    @IBOutlet var creatorTitleLabel: UILabel?

    /// Long Press Gesture Recognizer
    private var longPressGestureRecognizer: UILongPressGestureRecognizer?

    /// Is Pressed State
    private var isPressed: Bool = false

    // MARK: - Init

    // ------------------------------------------------------------------------------

    public override func awakeFromNib() {
        super.awakeFromNib()

        configureGestureRecognizer()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
    }

    // MARK: - Custom setup

    // ------------------------------------------------------------------------------

    func setup() {
        layer.cornerRadius = 4
        layer.masksToBounds = true

        creatorImageView?.layer.cornerRadius = 25 / 2
        creatorImageView?.layer.masksToBounds = true
    }

    // MARK: - Gesture Recognizer

    // ------------------------------------------------------------------------------

    private func configureGestureRecognizer() {
        // Long Press Gesture Recognizer
        #if os(iOS)
            longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(gestureRecognizer:)))
            longPressGestureRecognizer?.minimumPressDuration = 0.1
            addGestureRecognizer(longPressGestureRecognizer!)
        #endif
    }

    @objc internal func handleLongPressGesture(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            handleLongPressBegan()
        } else if gestureRecognizer.state == .ended || gestureRecognizer.state == .cancelled {
            handleLongPressEnded()
        }
    }

    internal func handleLongPressBegan() {
        guard !isPressed else {
            return
        }

        isPressed = true
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2, options: .beginFromCurrentState, animations: {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }, completion: nil)
    }

    internal func handleLongPressEnded() {
        guard isPressed else {
            return
        }

        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.2, options: .beginFromCurrentState, animations: {
            self.transform = CGAffineTransform.identity
        }) { _ in
            self.isPressed = false
        }
    }
}
