//
//  ProfileViewController.swift
//  Twittster
//
//  Created by Developer on 11/4/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit

class ProfileViewController:UIViewController, UITableViewDelegate, UITableViewDataSource, MainTweetCellDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    weak var profileHeaderCell:ProfileBannerViewCell!
    var tableViewDataBackArray = [Tweet]()
    
    var user:TwittsterUser!
    
    var profileBannerURL:URL?
    
    var tweetsArray = [Tweet]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if user.screenName == TwittsterUser.currentUser?.screenName {
            self.title = "Me"
        }
        else {
            self.title = user.name
        }
        
        self.setupTableView()
        // Do any additional setup after loading the view.
        
        self.callAPI {
            self.updateTableView()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func callAPI(success: @escaping ()->()) {
        let manager = TwitterServer.sharedInstance
        manager.getTimelineForUser(user,
                                   success: { (response) in
                                    print("First API success")
                                    self.callSecondAPI {
                                        success()
                                    }
                                    },
                                   failure: { (error:Error?) in
                                    print(error!.localizedDescription)
                                    })
    }
    
    func callSecondAPI(secondAPISuccess: @escaping ()->()) {
        let manager = TwitterServer.sharedInstance
        manager.getProfileBannerForUser(user,
                                        success: { (url:URL?) in
                                            print("Second API success")
                                            self.profileBannerURL = url
                                            secondAPISuccess()
        },
                                        failure: { (error:Error?) in
                                            print("BannerURL Error = \(error)")
        })
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
        let manager = TwitterServer.sharedInstance
        if let homeTimeline = manager.userTimeline {
            self.tweetsArray = homeTimeline
        }
        
        self.tableViewDataBackArray = self.tweetsArray
        self.tableView.reloadData()
    }
    
    func setupTableView() {
        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedSectionHeaderHeight = 25;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }
        else {
            return tableViewDataBackArray.count
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserStateCell", for: indexPath) as! UserStateCell

            cell.user = user
            return cell
        }
        
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MainTweetCell", for: indexPath) as! MainTweetCell
            cell.delegate = self
            cell.tweet = self.tableViewDataBackArray[indexPath.row] 
            cell.tag = indexPath.row

            return cell
        }
    }
    
    

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            let profileViewHeader = tableView.dequeueReusableCell(withIdentifier: "ProfileBannerHeaderView") as! ProfileBannerViewCell
            
            profileViewHeader.user = self.user
            
            self.profileHeaderCell = profileViewHeader
            return profileViewHeader
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
//        if section == 0 {
//            
//            if let resize = self.headerResize {
//                return self.view.bounds.height * 0.35 * CGFloat(resize / 100)
//            }
//            
//            return self.view.bounds.height * 0.35
//        }
//        return 0
        return UITableViewAutomaticDimension
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    
    @IBAction func didPan(_ sender: UIPanGestureRecognizer) {
        
        let location = sender.translation(in: view)
//        let velocity = sender.velocity(in: view)
        
        if sender.state == .began {
            print("USER BEGIN")

        }
        else if sender.state == .changed {
            print("X is =  \(location.y)")
            
            self.profileHeaderCell.updateHeight(y: location.y)

            UIView.setAnimationsEnabled(false)
            tableView.beginUpdates()
            tableView.endUpdates()
            UIView.setAnimationsEnabled(true)
            
            print("USER PANNED")
        }
        else if sender.state == .ended {
            print("USER PAN ENDED")

            self.profileHeaderCell.restoreHeight()
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // MARK: - MainTweet Cell Delegate
    func userDidClickReplyMessage(tweetOfReceiver: Tweet) {
                self.performSegue(withIdentifier: "SegueToComposeNaviVC", sender: tweetOfReceiver)
    }
    
    func updateModelWith(tweet: Tweet) {
        let server = TwitterServer.sharedInstance
        server.updateTweetInUserTimeline(withTweet: tweet)
    }
    
    func userDidClickProfilePic(user: TwittsterUser) {
        
        //Only segue to another person's profile
        if user.idString != self.user.idString {
            print("Pushing to user = \(user.name)")
            
            let anotherProfileVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController")
            
            let segue = UIStoryboardSegue(identifier: "SegueToProfileViewController",
                                          source: self,
                                          destination: anotherProfileVC,
                                          performHandler: {
                                            
                                                    self.navigationController?.show(anotherProfileVC, sender: self)
                                            
            })
            self.prepare(for: segue, sender: user)
            segue.perform()
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
            if let receiverTweet = sender as? Tweet {
                composeVC.replyToTweet = receiverTweet
            }
        }
        
        if segue.identifier == "SegueToDetailViewController" {
            
            let cell = sender as! MainTweetCell
            let detailVC = segue.destination as! DetailViewController
            
            let chosenTweetID = self.tableViewDataBackArray[cell.tag].id
            detailVC.tweet = TwitterServer.sharedInstance.userTimeline?.first(where: { (eachTweet) -> Bool in
                return eachTweet.id.intValue == chosenTweetID?.intValue
            })
            detailVC.timelineOrMentions = "Profile"
        }
        
        if segue.identifier == "SegueToProfileViewController" {
            
            let profileVC = segue.destination as! ProfileViewController
            profileVC.user = sender as! TwittsterUser
            
        }
        
     }
 
    
}
