//
//  MainViewController.swift
//  Twittster
//
//  Created by Developer on 10/27/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!

    var tweetsArray:[Tweet]?
    var tableViewDataBackArray = [Tweet]()
    
    let server = TwitterServer.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableView()
        // Do any additional setup after loading the view.
        
        self.callAPI {
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func callAPI(_: ()->()) {
        
        server.getTimeline(success: { (response:[Tweet]) in
            
            self.tweetsArray = response
            self.updateTableView()
            
        }) { (error:Error?) in
                
        }
    }
    
    func updateTableView() {
        
        if let tweetsArray = self.tweetsArray {
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
        
        let tweet = self.tableViewDataBackArray[indexPath.row]
        
        cell.tweet = tweet
        
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
    @IBAction func onLogout(_ sender: AnyObject) {
        
        TwitterServer.sharedInstance.logout()
    }
    
}
