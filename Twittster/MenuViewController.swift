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
    
    let twitterUsers = TwittsterUser.userArray
    let currentUser = TwittsterUser.currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableView()
        // Do any additional setup after loading the view.
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let timelineNaviVC = storyboard.instantiateViewController(withIdentifier: "MainNavigationControllerID") as! UINavigationController
        let timelineVC = storyboard.instantiateViewController(withIdentifier: "MainViewController")
        timelineVC.title = "HOME"
        timelineNaviVC.setViewControllers([timelineVC], animated: false)
        tableViewDataBackArray.append(timelineNaviVC)

        
        let mentionsNaviVC = storyboard.instantiateViewController(withIdentifier: "MainNavigationControllerID") as! UINavigationController
        let mentionsVC = MentionsViewController.instantiate()
        mentionsVC.title = "MENTIONS"
        mentionsNaviVC.setViewControllers([mentionsVC], animated: false)
        tableViewDataBackArray.append(mentionsNaviVC)
        
        let profileNaviVC = storyboard.instantiateViewController(withIdentifier: "MainNavigationControllerID") as! UINavigationController
        let profileVC = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        profileVC.title = "PROFILE"
        profileVC.user = TwittsterUser.currentUser
        profileNaviVC.setViewControllers([profileVC], animated: false)
        tableViewDataBackArray.append(profileNaviVC)
        
        
        //Set inital VC
        hamburgerVC.contentVC = tableViewDataBackArray[0] as! UINavigationController
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
        return 3
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
        return tableViewDataBackArray.count
        }
        else if section == 1 {
            let userArray = TwittsterUser.userArray
            return userArray.count
        }
        else {
            return 1
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
        else if indexPath.section == 1 {  //UserAccountCell
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserAccountCell", for: indexPath) as! UserAccountCell

            if let userJson =  try? JSONSerialization.jsonObject(with: TwittsterUser.userArray[indexPath.row], options: []) {
                
                let user = TwittsterUser(withJson: userJson as! NSDictionary)
                cell.userNameLabel.text = user.screenName
            }

            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCell", for: indexPath) as! AddCell
            return cell
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        
        if indexPath.section == 0 {
            let mentionsNaviVC = tableViewDataBackArray[indexPath.row] as! UINavigationController
            hamburgerVC.contentVC = mentionsNaviVC
        }
        
        //Chose user account
        if indexPath.section == 1 {
            if indexPath.row != 0 {
                TwitterServer.sharedInstance.login(
                    success: {
                        print("NEW LOGIN")
                },
                    failure: {
                        
                })
            }
        }
        
        //Add user account
        if indexPath.section == 2 {
            
            TwitterServer.sharedInstance.logout()
        }
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
