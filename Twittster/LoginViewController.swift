//
//  ViewController.swift
//  Twittster
//
//  Created by Developer on 10/27/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    var twitterClient = TwitterServer.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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

