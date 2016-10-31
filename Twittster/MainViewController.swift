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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableView()
        self.setupRefreshControl()
        
        self.callAPI { 
        }
        
        let notificationName = Notification.Name(kRetweetedNotificationName)
        NotificationCenter.default.addObserver(forName: notificationName, object: nil, queue: OperationQueue.main) { (notification: Notification) in
            
            self.updateTableView()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateTableView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func callAPI(success: @escaping ()->()) {
        
        server.getTimeline(success: { (response:[Tweet]) in
            
            self.tweetsArray = TwitterServer.sharedInstance.timeline
            self.updateTableView()
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
        self.callAPI {
            refreshControl.endRefreshing()
        }
    }
    
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
        cell.delegate = self
        return cell
    }
    
    
    
     // MARK: - Navigation
    
//    func userDidClickDirectMessage(directMessageToTweet: Tweet) {
//        self.performSegue(withIdentifier: "SegueToComposeNaviVC", sender: directMessageToTweet)
//    }
    
    func userDidClickDirectMessage(tweetOfReceiver: Tweet) {
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
        }
        
        if segue.identifier == "SegueToComposeNaviVC" {
            
            let naviVC = segue.destination as! UINavigationController
            let composeVC = naviVC.viewControllers[0] as! ComposeViewController
            if let receiverTweet = sender as? Tweet {
                composeVC.reciever = receiverTweet.user
            }
        }

        
        
     }
 
    @IBAction func onLogout(_ sender: AnyObject) {
        
        TwitterServer.sharedInstance.logout()
    }
    
}
