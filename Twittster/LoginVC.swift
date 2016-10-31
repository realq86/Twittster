//
//  LoginVC.swift
//  Twittster
//
//  Created by Developer on 10/30/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    var twitterClient = TwitterServer.sharedInstance
    
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        self.loginButton.layer.cornerRadius = 1.0
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
    
    @IBAction func onLoginButton(_ sender: AnyObject) {
        
        self.twitterClient.login(
            success: {
                
                self.performSegue(withIdentifier: "SegueToHome", sender: sender)
                
            },failure: {
        })
    }
    
    

}
