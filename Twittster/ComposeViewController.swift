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
    
    @IBOutlet weak var tweetButton: UIBarButtonItem!
    @IBOutlet weak var charCountLabel: UILabel!
    
    
    var receiver:TwittsterUser?
    
    var replyToTweet:Tweet?
    
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
        
        self.setupTextViewPlaceHolder()
    }
    
    
    func setupTextViewPlaceHolder() {
        if let replyToTweet = self.replyToTweet {
            
            self.textView.text = (replyToTweet.user.screenName)! + " "
        }
        
        if let receiver = self.receiver {
//            self.textView.text = receiver.screenName + " "
            self.tweetButton.title = "Message"
        }
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        let chars = textView.text.characters
        self.charCountLabel.text = String(chars.count)
    }

    
    @IBAction func touchOnTweet(_ sender: AnyObject) {
        
        if let tweetString = self.textView.text {
        
            
            if replyToTweet != nil {
                self.sendReplyMessage(tweetString)

            }
            else if receiver != nil {
                self.directMessage(receiver: self.receiver!, message: self.textView.text)
            }
            else {
                self.tweetMessage(tweetString)

            }
        }
    }
    
    
    func tweetMessage(_ message:String) {
        let server = TwitterServer.sharedInstance
        
        weak var weakself = self
        server.postTweet(
            withText: message,
            success: { (newTweet:Tweet) in
                
                server.addNewTweet(tweet: newTweet)
                print("Tweet sent!!!")
                weakself?.finishedCompsing()
            },
            failure: { (error:Error?) in
                print(error!.localizedDescription)
        })
    }
    
    func sendReplyMessage(_ message:String) {
        let server = TwitterServer.sharedInstance
        
        weak var weakself = self
        server.postReplyMessageTo(
            replyToTweet: replyToTweet!,
            withText: message,
            success: { (newTweet:Tweet) in
                
                server.addNewTweet(tweet: newTweet)
                print("Reply sent!!!")
                weakself?.finishedCompsing()
            },
            failure: { (error:Error?) in
                print(error!.localizedDescription)
        })
    }
    
    func directMessage(receiver:TwittsterUser, message:String) {
        let server = TwitterServer.sharedInstance
        
        weak var weakself = self
        server.postDirectMessageTo(
            receiver:receiver,
            withText: message,
            success: { (response:Any) in
                
                print("Direct Message sent!!!")
                weakself?.finishedCompsing()
            },
            failure: { (error:Error?) in
                print(error!.localizedDescription)
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
