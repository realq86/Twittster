//
//  MentionsViewController.swift
//  Twittster
//
//  Created by Developer on 11/3/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit

class MentionsViewController: MainViewController {
    
    class func instantiate() -> MentionsViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let instance = storyboard.instantiateViewController(withIdentifier: "MainViewController")

        object_setClass(instance, MentionsViewController.self)
        return (instance as? MentionsViewController)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "MENTIONS"
        self.timelineOrMentions = "Mentions"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func callAPI(success: @escaping () -> ()) {
        
//        weak var weakSelf = self
        server.getMentions(
            success: { (response) in
                success()
        },
            failure: { (error:Error?) in
        })
    }
    
    override func updateTableView() {
        if let tweetsArray = TwitterServer.sharedInstance.mentionsTimeline {
            self.tableViewDataBackArray = tweetsArray
        }
        self.tableView.reloadData()
    }
    
    // MARK: - Notification From TableViewCell
    
//    override func userUpdatedTweetNotification(sender:Notification) {
//        let tweet = sender.userInfo?["Tweet"] as! Tweet
//        
//        let server = TwitterServer.sharedInstance
//        server.updateTweetInMentions(withTweet: tweet)
//        
//    }

    override func updateModelWith(tweet: Tweet) {
        let server = TwitterServer.sharedInstance
        server.updateTweetInMentions(withTweet: tweet)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "SegueToDetailViewController" {
            
            let cell = sender as! MainTweetCell
            let detailVC = segue.destination as! DetailViewController
            
            let chosenTweetID = self.tableViewDataBackArray[cell.tag].id
            detailVC.tweet = server.mentionsTimeline?.first(where: { (eachTweet) -> Bool in
                return eachTweet.id.intValue == chosenTweetID?.intValue
            })
            detailVC.timelineOrMentions = "Mentions"
        }
        else {
            super.prepare(for: segue, sender: sender)
        }
        
 
        
    }
 

}
