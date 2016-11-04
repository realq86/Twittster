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

        self.title = "Mentions"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func callAPI(success: @escaping () -> ()) {
        
        weak var weakSelf = self
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
