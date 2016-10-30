//
//  TwitterServer.swift
//  Twittster
//
//  Created by Developer on 10/27/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit
import BDBOAuth1Manager
class TwitterServer: NSObject {
    
    static let sharedInstance = TwitterServer()
    
    let manager = BDBOAuth1SessionManager(baseURL:URL(string: kTwitterURLString), consumerKey:kTwitterConsumerKey, consumerSecret: kTwitterConsumerSecret)!
    
    var timeline:[Tweet]?
    
    // MARK: - Login Methods
    var loginSuccessHandler:(()->())?
    var loginFailureHandler:(()->())?
    
    public func login(success:@escaping ()->(),failure:()->()) {
        
        self.loginSuccessHandler = success
        manager.deauthorize()
        weak var weakSelf = self
        manager.fetchRequestToken(withPath: kTwitterRequestTokenPath, method: "GET", callbackURL: kTWitterCallBackURL, scope: nil,success: { (requestToken:BDBOAuth1Credential?) in
                        print("FetchRquestToken: Success Token = \(requestToken?.token)")
                        weakSelf?.openAuthURLWithToken(requestToken?.token)
                    }) {(error:Error?) in
                        print("FetchRequestToken: Error = \(error)")
                        weakSelf?.loginFailureHandler?()
        }
    }
    
    public func logout() {
        TwittsterUser.currentUser = nil
        manager.deauthorize()
        let notificationName = Notification.Name(kUserLogoutNotificationName)
        NotificationCenter.default.post(name:notificationName, object: self)
    }
    
    private func openAuthURLWithToken(_ requestToken:String?) {
        guard let requestToken = requestToken
            else {
                return
        }
        let url = authURL(requestToken: requestToken)
        
        UIApplication.shared.open(url, options: [:]) { (success:Bool) in
            if success == false {
                print("Auth URL Error")
            }
        }
    }
    
    
    public func processOpenURL(url:URL) {
        
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        weak var weakSelf = self
        manager.fetchAccessToken(withPath: kTwitterAccessTokenPath, method: "POST", requestToken: requestToken,
            success: { (accessToken:BDBOAuth1Credential?) in
                
                print("FetchAccessToken: Success Token = \(accessToken?.description)")
                
                self.getCredentials(
                    success: { (user:TwittsterUser) in
                        TwittsterUser.currentUser = user
                    },
                    failure: { (error:Error?) in
                        weakSelf?.loginFailureHandler?()
                })
                
                weakSelf?.loginSuccessHandler?()
            
            }, failure: { (error:Error?) in
            
                print("FetchAccessToken Fail \(error)")
                weakSelf?.loginFailureHandler?()
        })
        
        
    }
    
    // MARK: Generic GET
    private func get(endPoint:String, success:@escaping (Any)->(), failure:@escaping (Error?)->()){
        manager.get(endPoint, parameters: nil, progress: nil,
                    success: { (task:URLSessionDataTask, response:Any?) in
                        success(response)
            }, failure: { (tast:URLSessionDataTask?, error:Error) in
                failure(error)
        })
    }
    
    // MARK: - GET Profile
    public func getCredentials(success: @escaping (TwittsterUser)->(), failure: @escaping (Error?)->()) {
        
        self.get(endPoint: kTwitterGETCredentials,
                success: { (response:Any) in
                    
                    let user = TwittsterUser(withJson: response as! NSDictionary)
                    success(user)
                    
                }) { (error:Error?) in
                    print(error?.localizedDescription)
                    failure(error)
        }
    }
    
    
    // MARK: - GET Timeline
    public func getTimeline(success: @escaping ([Tweet])->(), failure: @escaping (Error?)->()) {
        self.get(endPoint: kTwitterGETTimeLine,
                success: { (response:Any) in
                    print("GET TimeLine Response = \(response)")
                    let responseDic = response as! [NSDictionary]
                    let tweetsArray = Tweet.initTweetsWith(array: responseDic)
                    self.timeline = tweetsArray
                    print(tweetsArray.description)
                    success(tweetsArray)
                }) { (error:Error?) in
                    print("GET TimeLine Error = \(error?.localizedDescription)")
                    failure(error)
        }
    }
    

    func find(tweet:Tweet)->Tweet {
        return self.find(tweet: tweet, inModel: self.timeline!)
    }
    
    //Find the tweet with the same id in the Server Model
    func find(tweet:Tweet, inModel model:[Tweet])->Tweet {
        
        let tweetIDInt = tweet.id.intValue
        
        let index = model.index(where: { (eachTweet) -> Bool in
            if eachTweet.id.intValue == tweetIDInt {
                return true
            }
            else {
                return false
            }
        })
        
        print("PassedTweet \(tweet.debugDescription)")
        print("FoundTweet \(model[index!].debugDescription)")
        
        return model[index!]
    }
    
    
    
    
}
