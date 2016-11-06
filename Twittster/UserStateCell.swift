//
//  UserStateCell.swift
//  Twittster
//
//  Created by Developer on 11/5/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit

class UserStateCell: UITableViewCell {

    @IBOutlet weak var tweetCountLabel: UILabel!
    
    @IBOutlet weak var followingCountLabel: UILabel!
    
    @IBOutlet weak var followersCountLabel: UILabel!
    
    var user:TwittsterUser! {
        
        didSet {
            self.tweetCountLabel.text = user.tweetCount.stringValue
            
            self.followersCountLabel.text = user.followersCount.stringValue
            
            self.followingCountLabel.text = user.followingCount.stringValue
            
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
