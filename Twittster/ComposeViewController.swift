//
//  ComposeViewController.swift
//  Twittster
//
//  Created by Developer on 10/30/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var profileNameLabel: UILabel!
    
    @IBOutlet weak var screenNameLabel: UILabel!
    
    @IBOutlet weak var textView: UITextView!
    
    var reciever:TwittsterUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupViews()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setupViews() {
        
        let currentUser = TwittsterUser.currentUser
        
        if let profileURL = currentUser?.profileImageURLHTTPS {
            self.profileImageView.setImageWith(profileURL)
        }
        
        self.profileNameLabel.text = currentUser?.name
        self.screenNameLabel.text = currentUser?.screenName
    }
    
    
    @IBAction func touchOnTweet(_ sender: AnyObject) {
        
        if let tweetString = self.textView.text {
        
            if let tweetURLEncoded = tweetString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
                
                if reciever == nil {
                    self.tweetMessage(tweetString)
                }
                else {
                    self.sendDirectMessage(tweetString)
                }
            }
        }
        
    }
    
    
    func tweetMessage(_ tweetURLEncoded:String) {
        let server = TwitterServer.sharedInstance
        server.postTweet(
            withText: tweetURLEncoded,
            success: { (newTweet:Tweet) in
                
                let server = TwitterServer.sharedInstance
                server.addNewTweet(tweet: newTweet)
                self.finishedCompsing()
                
                print("Tweet sent!!!")
            },
            failure: { (error:Error?) in
                print(error?.localizedDescription)
        })
    }
    
    func sendDirectMessage(_ tweetURLEncoded:String) {
        let server = TwitterServer.sharedInstance
        server.postDirectMessageTo(
            reciever: reciever,
            withText: tweetURLEncoded,
            success: { (response:Any) in
                
                self.finishedCompsing()
                
                print("Message sent!!!")
            },
            failure: { (error:Error?) in
                print(error?.localizedDescription)
        })
    }
    
    @IBAction func touchOnCancel(_ sender: AnyObject) {
        self.finishedCompsing()
    }

    func finishedCompsing() {
        self.dismiss(animated: true) { 
            
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
