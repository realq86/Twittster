//
//  ProfileViewController.swift
//  Twittster
//
//  Created by Developer on 11/4/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var tableViewDataBackArray = [AnyObject]()
    
    var user:TwittsterUser!
    
    var profileBannerURL:URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            self.tableViewDataBackArray = homeTimeline
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
//        return tableViewDataBackArray.count
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileBackgroundCell", for: indexPath) as! ProfileBackgroundCell
        if let profileBanner = self.profileBannerURL {
            cell.backgroundImageView.setImageWith(profileBanner)
        }
        return cell
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
