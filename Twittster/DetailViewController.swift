//
//  DetailViewController.swift
//  Twittster
//
//  Created by Developer on 10/29/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    var tweet:Tweet!
    
    //Retween info in StackView index 0
    @IBOutlet weak var retweetPanel: UIView!
    @IBOutlet weak var retweetedByUserLabel: UILabel!
    
    //Profile Views in StackView index 1
    @IBOutlet weak var profilePanel: UIView!
    @IBOutlet weak var profileImageViewContainer: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var screenName: UILabel!
    
    
    //TweetContent Views in StackView index 2
    @IBOutlet weak var tweetLabel: ActiveLabel!
    @IBOutlet weak var tweetTime: UILabel!
    
    
    
    //TweetStat Views in StackView index 3
    @IBOutlet weak var tweetStatPanel: UIView!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var likeCount: UILabel!
    
    //Button Views in StackView index 4
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    
    @IBOutlet weak var tweetImage: UIImageView!
    
    var timelineOrMentions:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setupViews()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setupViews() {
        
        //Sync up the tweet from the MainVC with the Server's Model
//        self.tweet = TwitterServer.sharedInstance.find(tweet: self.tweet)
        self.setupViews(with: self.tweet)
    }
    
    func setupViews(with tweet:Tweet) {
        if let imageURL = tweet.user.profileImageURLHTTPS {
            self.profileImage.setImageWith(imageURL)
        }
        self.name.text = tweet.user.name as String?
        
        self.screenName.text = tweet.user.screenName as String!
        
        self.tweetLabel.text = tweet.text
        
        self.tweetTime.text = tweet.created_atLocalFormate
        
        self.retweetCount.text = tweet.retweetCount.stringValue
        
        self.starButton.isSelected = tweet.favorited
        self.likeCount.text = tweet.favoritCount.stringValue
        
        self.retweetPanel.isHidden = true
        if let retweetedBy = tweet.retweetedBy {
            self.retweetedByUserLabel.text = retweetedBy.user.name
            self.retweetPanel.isHidden = false
        }
        
        self.starButton.imageView?.contentMode = .scaleAspectFit
        self.retweetButton.imageView?.contentMode = .scaleAspectFit
        self.replyButton.imageView?.contentMode = .scaleAspectFit
        
        self.profileImage.layer.cornerRadius = 10.0
        
        self.profileImageViewContainer.layer.cornerRadius = 10.0
        self.profileImageViewContainer.layer.shadowColor = UIColor.black.cgColor
        self.profileImageViewContainer.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        self.profileImageViewContainer.layer.shadowRadius = 2.0
        self.profileImageViewContainer.layer.shadowOpacity = 1.0

        if let imageURL = tweet.image {
            self.tweetImage.setImageWith(imageURL)
        }
        
    }
    
    

    func refreshViewAndUpdateServerModel(with tweet:Tweet) {
        let server = TwitterServer.sharedInstance
        
        if timelineOrMentions == "Timeline" {
            server.updateTweetInTimeline(withTweet: tweet)
        }
        else if timelineOrMentions == "Mentions" {
            server.updateTweetInMentions(withTweet: tweet)
        }
        else if timelineOrMentions == "Profile" {
            server.updateTweetInUserTimeline(withTweet: tweet)
        }
        
        self.setupViews(with: tweet)
    }
    
    
    @IBAction func touchOnRetweet(_ sender: UIButton) {
        weak var weakSelf = self
        TwitterServer.sharedInstance.postRetweet(
            tweet: self.tweet,
            success: { (tweet:Tweet) in
                weakSelf?.tweet = tweet
                weakSelf?.refreshViewAndUpdateServerModel(with: self.tweet)
            },
            failure: { (error:Error?) in
        })
    }
    
    

    @IBAction func touchOnStar(_ sender: UIButton) {

        //Toggle the selected state, also means isSelected is the user's chocie
        sender.isSelected = !sender.isSelected
        weak var weakSelf = self
        if sender.isSelected == true {

            TwitterServer.sharedInstance.postFavoriteCreate(
                toTweetID: self.tweet.id,
                success: { (response:Tweet) in
                    weakSelf?.tweet = response
                    weakSelf?.refreshViewAndUpdateServerModel(with: self.tweet)
                },
                failure: { (error:Error?) in
                    sender.isSelected = false
                    weakSelf?.setupViews(with: self.tweet)
            })
        }
        else {
            
            TwitterServer.sharedInstance.postFavoriteDestroy(
                toTweetID: self.tweet.id,
                success: { (response:Tweet) in
                    weakSelf?.tweet = response
                    weakSelf?.refreshViewAndUpdateServerModel(with: self.tweet)
                },
                failure: { (error:Error?) in
                    sender.isSelected = true
                    weakSelf?.setupViews(with: self.tweet)
            })
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "SegueToComposeNaviVC" {
            
            let naviVC = segue.destination as! UINavigationController
            let composeVC = naviVC.viewControllers[0] as! ComposeViewController
            
            composeVC.replyToTweet = self.tweet
        }
        
        if segue.identifier == "SeugeToComposeDirectMessage" {
            let naviVC = segue.destination as! UINavigationController
            let composeVC = naviVC.viewControllers[0] as! ComposeViewController
            
            composeVC.receiver = self.tweet.user
        }
        
    }
    

}
