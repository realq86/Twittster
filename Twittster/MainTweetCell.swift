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
    
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    
    
    
    var retweetBy:Tweet?
    
    var tweet:Tweet! {

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
        
            //Buttons
            self.starButton.isSelected = tweet!.favorited
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.starButton.imageView?.contentMode = .scaleAspectFit
        self.retweetButton.imageView?.contentMode = .scaleAspectFit
        self.replyButton.imageView?.contentMode = .scaleAspectFit
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func refreshViewAndUpdateServerModel(with tweet:Tweet) {
        let server = TwitterServer.sharedInstance
        server.updateTweetInModel(withTweet: self.tweet)
    }
    
    @IBAction func touchOnStar(_ sender: UIButton) {
        
        //Toggle the selected state, also means isSelected is the user's chocie
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected == true {
            
            TwitterServer.sharedInstance.postFavoriteCreate(
                toTweetID: self.tweet.id,
                success: { (response:Tweet) in
                    self.tweet = response
                    self.refreshViewAndUpdateServerModel(with: self.tweet)
                },
                failure: { (error:Error?) in
                    sender.isSelected = false
            })
        }
        else {
            
            TwitterServer.sharedInstance.postFavoriteDestroy(
                toTweetID: self.tweet.id,
                success: { (response:Tweet) in
                    self.tweet = response
                    self.refreshViewAndUpdateServerModel(with: self.tweet)
                },
                failure: { (error:Error?) in
                    sender.isSelected = true
                    
            })
        }
        
        
    }
    
    
    

}
