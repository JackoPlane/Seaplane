//
//  SettingsHeaderTableViewCell.swift
//  Floatplane
//
//  Created by Jack Perry on 7/5/19.
//  Copyright © 2019 Yoshimi Robotics. All rights reserved.
//

import UIKit
import Foundation


public class SettingsHeaderTableViewCell: UITableViewCell
{
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var subtitleLabel: UILabel!
    
    @IBOutlet var profileImageView: UIImageView!
    
    
    
    public override func willMove(toSuperview newSuperview: UIView?)
    {
        super.willMove(toSuperview: newSuperview)
        
        // Round the corners of our image view
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height / 2
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        subtitleLabel.text = nil
        profileImageView.image = nil
    }
    
}
