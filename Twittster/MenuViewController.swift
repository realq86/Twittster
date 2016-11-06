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
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let timelineVC = storyboard.instantiateViewController(withIdentifier: "MainViewController")
//        timelineVC.title = "Timeline"
//        let timelineNaviVC = UINavigationController(rootViewController: timelineVC)
//        tableViewDataBackArray.append(timelineNaviVC)
//    
//        let mentionsVC = MentionsViewController.instantiate()
//        let mentionsNaviVC = UINavigationController(rootViewController: mentionsVC)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let timelineNaviVC = storyboard.instantiateViewController(withIdentifier: "MainNavigationControllerID") as! UINavigationController
        let timelineVC = storyboard.instantiateViewController(withIdentifier: "MainViewController")
        timelineVC.title = "HOME"
        timelineNaviVC.setViewControllers([timelineVC], animated: false)
        tableViewDataBackArray.append(timelineNaviVC)

        
        let mentionsNaviVC = storyboard.instantiateViewController(withIdentifier: "MainNavigationControllerID") as! UINavigationController
        let mentionsVC = MentionsViewController.instantiate()
        mentionsNaviVC.setViewControllers([mentionsVC], animated: false)
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
        return tableViewDataBackArray.count
        }
        else {
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
            
            let menuItems = tableViewDataBackArray[indexPath.row] as! UINavigationController
            let menuVC = menuItems.viewControllers[0]
            cell.menuTitleLabel.text = menuVC.title
            
            return cell
        }
        else {
            return UITableViewCell()
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let mentionsNaviVC = tableViewDataBackArray[indexPath.row] as! UINavigationController
        hamburgerVC.contentVC = mentionsNaviVC
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return self.view.bounds.height * 0.25
        }
        else {
            return UITableViewAutomaticDimension
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
