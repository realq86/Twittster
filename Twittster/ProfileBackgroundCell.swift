//
//  ProfileBackgroundCell.swift
//  Twittster
//
//  Created by Developer on 11/4/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit

class ProfileBackgroundCell: UITableViewCell {

    @IBOutlet weak var backgroundImageView: UIImageView!
    
    var user:TwittsterUser! {
        didSet {
            if let backgroundImageURL = user.profileBackgroundImageHTTPS {
                self.backgroundImageView.setImageWith(backgroundImageURL)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
