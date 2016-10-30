//
//  MainTweetCell.swift
//  Twittster
//
//  Created by Developer on 10/29/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit

class MainTweetCell: UITableViewCell {

    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var userScreenName: UILabel!
    @IBOutlet weak var tweetContent: UILabel!
    @IBOutlet weak var retweetScreenName: UILabel!
    @IBOutlet weak var retweetPanel: UIView!
    
    var retweetBy:Tweet?
    
    var tweet:Tweet? {

        didSet {
            self.retweetPanel.isHidden = true
            if let retweetedBy = tweet?.retweetedBy {
                
                self.retweetPanel.isHidden = false
                
                self.retweetBy = retweetedBy
                self.retweetScreenName.text = self.retweetBy?.user.name
            }
            
            
            if let profileImageURL = self.tweet?.user.profileImageURLHTTPS {
                self.profileImageView.setImageWith(profileImageURL)
            }
            
            self.profileName.text = tweet!.user.name as String?
            
            self.userScreenName.text = tweet!.user.screenName as String
            
            self.tweetContent.text = tweet?.text
            
            
            
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
