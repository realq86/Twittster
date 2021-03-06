//
//  MainTweetCell.swift
//  Twittster
//
//  Created by Developer on 10/29/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit

@objc protocol MainTweetCellDelegate {
    func userDidClickReplyMessage(tweetOfReceiver:Tweet)
    
    func updateModelWith(tweet:Tweet)
    
    func userDidClickProfilePic(user:TwittsterUser)
}

class MainTweetCell: UITableViewCell {

    
    @IBOutlet weak var profileImageViewContainer: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var userScreenName: UILabel!
    @IBOutlet weak var tweetContent: ActiveLabel!
    @IBOutlet weak var retweetScreenName: UILabel!
    @IBOutlet weak var retweetPanel: UIView!
    
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    
    @IBOutlet weak var minFromNow: UILabel!
    @IBOutlet weak var tweetImage: UIImageView!
    
    weak var delegate:MainTweetCellDelegate?
    
    var retweetBy:Tweet?
    
    var timelineOrMentions:String!
    
    var tweet:Tweet! {

        didSet {
            self.retweetPanel.isHidden = true
            if let retweetedBy = tweet?.retweetedBy {
                
                self.retweetPanel.isHidden = false
                
                self.retweetBy = retweetedBy
                self.retweetScreenName.text = (self.retweetBy?.user.screenName)!
            }
            
            
            if let profileImageURL = self.tweet?.user.profileImageURLHTTPS {
                self.profileImageView.setImageWith(profileImageURL)
            }
            
            self.profileName.text = tweet!.user.name as String?
            
            self.userScreenName.text = tweet!.user.screenName as String
            
            self.tweetContent.text = tweet?.text
        
            //Buttons
            self.starButton.isSelected = tweet!.favorited
            
            self.minFromNow.text = tweet!.minFromNow + "m ago"
            
            if let imageURL = tweet.image {
                self.tweetImage.setImageWith(imageURL)
            }
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.starButton.imageView?.contentMode = .scaleAspectFit
        self.retweetButton.imageView?.contentMode = .scaleAspectFit
        self.replyButton.imageView?.contentMode = .scaleAspectFit
        
        let profilePicGesture = UITapGestureRecognizer(target: self, action: #selector(touchOnProfilePic(sender:)))
        profilePicGesture.numberOfTapsRequired = 1
        self.profileImageView.addGestureRecognizer(profilePicGesture)
        
        self.profileImageView.layer.cornerRadius = 10.0
        
        self.profileImageViewContainer.layer.cornerRadius = 10.0
        self.profileImageViewContainer.layer.shadowColor = UIColor.black.cgColor
        self.profileImageViewContainer.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        self.profileImageViewContainer.layer.shadowRadius = 2.0
        self.profileImageViewContainer.layer.shadowOpacity = 1.0
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func refreshViewAndUpdateServerModel(with tweet:Tweet) {
//        let server = TwitterServer.sharedInstance
//        
//        if timelineOrMentions == "Timeline" {
//            server.updateTweetInTimeline(withTweet: tweet)
//        }
//        else if timelineOrMentions == "Mentions" {
//            server.updateTweetInMentions(withTweet: tweet)
//        }
//        server.updateTweetInModel(withTweet: tweet)
        
//        let notificationName = Notification.Name(kRetweetedNotificationName)
//        NotificationCenter.default.post(name: notificationName,
//                                        object: self,
//                                        userInfo: ["Tweet":tweet])
        
        self.delegate?.updateModelWith(tweet: tweet)
    }
    
    
    func touchOnProfilePic(sender:UITapGestureRecognizer) {
        print("TAP ON PROFILE PIC")
        
//        let tapOnProfileNotification = Notification.Name("TapOnProfilePicNotification")
//        NotificationCenter.default.post(
//            name: tapOnProfileNotification,
//            object: nil,
//            userInfo: ["User":tweet.user])
        
        self.delegate?.userDidClickProfilePic(user: tweet.user)
    }
    
    
    @IBAction func touchOnReply(_ sender: UIButton) {
        self.delegate?.userDidClickReplyMessage(tweetOfReceiver: self.tweet)
    }
    
    @IBAction func onTouchRetweet(_ sender: UIButton) {
        TwitterServer.sharedInstance.postRetweet(
            tweet: self.tweet,
            success: { (tweet:Tweet) in
                self.tweet = tweet
                self.refreshViewAndUpdateServerModel(with: self.tweet)
            },
            failure: { (error:Error?) in
        })
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
