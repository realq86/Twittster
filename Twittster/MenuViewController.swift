//
//  MenuViewController.swift
//  Twittster
//
//  Created by Developer on 11/2/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var tableViewDataBackArray = [AnyObject]()
    
    var hamburgerVC:HamburgerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableView()
        // Do any additional setup after loading the view.
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let timelineVC = storyboard.instantiateViewController(withIdentifier: "MainNavigationControllerID")
        tableViewDataBackArray.append(timelineVC)
    
        let mentionsVC = MentionsViewController.instantiate()
        let mentionsNaviVC = UINavigationController(rootViewController: mentionsVC)
            
        
        tableViewDataBackArray.append(mentionsNaviVC)
        hamburgerVC.contentVC = mentionsNaviVC
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Menu ViewWillAppear")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = "TEST"
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            let timelineNaviVC = tableViewDataBackArray[indexPath.row] as! UINavigationController
            
            let timelineVC = timelineNaviVC.viewControllers[0] as! MainViewController
//            timelineVC.tableView.isUserInteractionEnabled = false
            
            
            hamburgerVC.contentVC = timelineNaviVC
        }
        else if indexPath.row == 1 {
            let mentionsVC = tableViewDataBackArray[indexPath.row] as! UINavigationController
            hamburgerVC.contentVC = mentionsVC
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
