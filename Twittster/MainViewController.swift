//
//  MainViewController.swift
//  Twittster
//
//  Created by Developer on 10/27/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MainTweetCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    var tweetsArray:[Tweet]?
    var tableViewDataBackArray = [Tweet]()
    
    let server = TwitterServer.sharedInstance
    var timelineOrMentions:String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Timeline"
        self.timelineOrMentions = "Timeline"
        self.setupTableView()
        self.setupRefreshControl()
        
        weak var weakSelf = self
        self.callAPI {
            weakSelf?.updateTableView()
        }
        
        let notificationName = Notification.Name(kRetweetedNotificationName)
        NotificationCenter.default.addObserver(forName: notificationName, object: nil, queue: OperationQueue.main) { (notification: Notification) in
            
            self.updateTableView()
        }
        
        let touchOnProfilePicNotification = Notification.Name("TapOnProfilePicNotification")
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(userDidClickProfilePic(sender:)),
                                               name: touchOnProfilePicNotification,
                                               object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateTableView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func callAPI(success: @escaping ()->()) {
        
//        weak var weakSelf = self
        server.getTimeline(success: { (response:[Tweet]) in
            success()
        }) { (error:Error?) in
        }
    }
    
    func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        weak var weakSelf = self
        self.callAPI {
            refreshControl.endRefreshing()
            weakSelf?.updateTableView()
        }
    }
    
    
    // MARK: - TableView Methods
    
    func updateTableView() {
        
        if let tweetsArray = TwitterServer.sharedInstance.timeline {
            self.tableViewDataBackArray = tweetsArray
        }
        self.tableView.reloadData()
    }
    
    func setupTableView() {
        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewDataBackArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainTweetCell", for: indexPath) as! MainTweetCell
        
        cell.tag = indexPath.row
        
        let tweet = self.tableViewDataBackArray[indexPath.row]
        
        cell.tweet = tweet
        cell.timelineOrMentions = self.timelineOrMentions
        cell.delegate = self
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
    
    }
    
    
    
     // MARK: - Navigation
    
//    func userDidClickDirectMessage(directMessageToTweet: Tweet) {
//        self.performSegue(withIdentifier: "SegueToComposeNaviVC", sender: directMessageToTweet)
//    }
    
    
    func userDidClickProfilePic(sender:Notification) {
        
        print(sender)
        
        self.performSegue(withIdentifier: "SegueToProfileViewController", sender: sender.userInfo!["User"])
        
    }
    
    func userDidClickReplyMessage(tweetOfReceiver: Tweet) {
        self.performSegue(withIdentifier: "SegueToComposeNaviVC", sender: tweetOfReceiver)
    }
    
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        
        if segue.identifier == "SegueToDetailViewController" {
            
            let cell = sender as! MainTweetCell
            let detailVC = segue.destination as! DetailViewController
            
            let chosenTweetID = self.tableViewDataBackArray[cell.tag].id
            detailVC.tweet = server.timeline?.first(where: { (eachTweet) -> Bool in
                return eachTweet.id.intValue == chosenTweetID?.intValue
            })
            detailVC.timelineOrMentions = "Timeline"

        }
        
        if segue.identifier == "SegueToComposeNaviVC" {
            
            let naviVC = segue.destination as! UINavigationController
            let composeVC = naviVC.viewControllers[0] as! ComposeViewController
            if let receiverTweet = sender as? Tweet {
                composeVC.replyToTweet = receiverTweet
            }
        }
        
        if segue.identifier == "SegueToProfileViewController" {
            
            let profileVC = segue.destination as! ProfileViewController
            profileVC.user = sender as! TwittsterUser
            
        }
     }
    
    
    
 
    @IBAction func onLogout(_ sender: AnyObject) {
        
        TwitterServer.sharedInstance.logout()
    }
    
}
