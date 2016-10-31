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
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var screenName: UILabel!
    
    
    //TweetContent Views in StackView index 2
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var tweetTime: UILabel!
    
    
    
    //TweetStat Views in StackView index 3
    @IBOutlet weak var tweetStatPanel: UIView!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var likeCount: UILabel!
    
    //Button Views in StackView index 4
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    
    
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
        self.tweet = TwitterServer.sharedInstance.find(tweet: self.tweet)
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
    }
    
    

    func refreshViewAndUpdateServerModel(with tweet:Tweet) {
        let server = TwitterServer.sharedInstance
        server.updateTweetInModel(withTweet: self.tweet)
        self.setupViews(with: self.tweet)
    }
    
    
    @IBAction func touchOnRetweet(_ sender: UIButton) {
        TwitterServer.sharedInstance.postRetweet(
            tweet: self.tweet,
            success: { (tweet:Tweet) in
                
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
                    self.setupViews(with: self.tweet)
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
                    self.setupViews(with: self.tweet)
            })
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
