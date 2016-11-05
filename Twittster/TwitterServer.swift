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
    
    // App wide data store
    var timeline:[Tweet]?
    var mentionsTimeline:[Tweet]?
    var userTimeline:[Tweet]?
    
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
        print(url.query as Any)
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
    private func get(endPoint:String, parameters: [String:String]?, success:@escaping (Any)->(), failure:@escaping (Error?)->()){
        manager.get(endPoint, parameters: parameters, progress: nil,
                    success: { (task:URLSessionDataTask, response:Any?) in
                        success(response!)
            }, failure: { (tast:URLSessionDataTask?, error:Error) in
                failure(error)
        })
    }
    
    // MARK: GET Profile
    public func getCredentials(success: @escaping (TwittsterUser)->(), failure: @escaping (Error?)->()) {
        
        self.get(endPoint: kTwitterGETCredentials,
                 parameters: nil,
                 success: { (response:Any) in
                    
                    let user = TwittsterUser(withJson: response as! NSDictionary)
                    success(user)
                    
                }) { (error:Error?) in
                    print(error!.localizedDescription)
                    failure(error)
        }
    }
    
    // MARK: GET Timeline
    public func getTimeline(success: @escaping ([Tweet])->(), failure: @escaping (Error?)->()) {
        self.get(endPoint: kTwitterGETTimeLine,
                 parameters: nil,
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

    // MARK: GET UserTimeline
    public func getTimelineForUser(_ user:TwittsterUser, success: @escaping ([Tweet])->(), failure: @escaping (Error?)->()) {
        
        let parameter = ["user_id":user.idString as String]
        self.get(endPoint: kTwitterGETUserTimeLine,
                 parameters: parameter,
                 success: { (response:Any) in
                    print("GET UserTimeLine Response = \(response)")
                    let responseDic = response as! [NSDictionary]
                    let tweetsArray = Tweet.initTweetsWith(array: responseDic)
                    self.userTimeline = tweetsArray
                    print(tweetsArray.description)
                    success(tweetsArray)
        }) { (error:Error?) in
            print("GET TimeLine Error = \(error?.localizedDescription)")
            failure(error)
        }
    }
    
    // MARK: GET Profile Banner
    public func getProfileBannerForUser(_ user:TwittsterUser, success: @escaping (URL?)->(), failure: @escaping (Error?)->()) {
        
        let parameter = ["user_id":user.idString as String]
        self.get(endPoint: kTwitterGETProfileBanner,
                 parameters: parameter,
                 success: { (response:Any) in
                    print("GET ProfileBanner Response = \(response)")
                    let responseDic = response as! NSDictionary
                    let imageURL = responseDic.value(forKeyPath: "sizes.mobile_retina.url") as! String
                    if let bannerURL = URL(string: imageURL) {
                        success(bannerURL)
                    }
                    else {
                        success(nil)
                    }
        }) { (error:Error?) in
            print("GET TimeLine Error = \(error?.localizedDescription)")
            failure(error)
        }
    }
    
    // MARK: GET Mentions
    public func getMentions(success: @escaping ([Tweet])->(), failure: @escaping (Error?)->()) {
        self.get(endPoint: kTwitterGETMentions,
                 parameters: nil,
                 success: { (response:Any) in
                    print("GET Mentions Response = \(response)")
                    let responseDic = response as! [NSDictionary]
                    let tweetsArray = Tweet.initTweetsWith(array: responseDic)
                    self.mentionsTimeline = tweetsArray
                    print(tweetsArray.description)
                    success(tweetsArray)
        }) { (error:Error?) in
            print("GET Mentions Error = \(error?.localizedDescription)")
            failure(error)
        }
    }
    
    // MARK: - Generic POST
    private func post(endPoint:String, parameters:Any?, success:@escaping (Any)->(), failure:@escaping (Error?)->()){
        manager.post(endPoint, parameters: parameters, progress: nil,
                     success: { (task:URLSessionDataTask, response:Any?) in
                        if let urlResponse = task.response as? HTTPURLResponse {
                            print("POST TASK = \(urlResponse.statusCode)")
                        }
                        success(response as Any)
            }, failure: { (tast:URLSessionDataTask?, error:Error) in
                failure(error)
        })
    }
    
    // MARK: POST Favorite Create
    public func postFavoriteCreate(toTweetID id:NSNumber, success: @escaping (Tweet)->(), failure: @escaping (Error?)->()) {
        let parameters:NSDictionary = ["id":id.stringValue] as NSDictionary
        
        
        self.post(endPoint:kTwitterPOSTFavoritesCreate, parameters:parameters, success: { (response:Any) in
            
            print(response)
            
            let updatedTweet = Tweet(withJson: response as! [String : Any])
            success(updatedTweet)
        
        }) { (error:Error?) in
            print(error!.localizedDescription)
            failure(error)
        }
    }
    
    // MARK: POST Favorite Destroy
    public func postFavoriteDestroy(toTweetID id:NSNumber, success: @escaping (Tweet)->(), failure: @escaping (Error?)->()) {
        let parameters:NSDictionary = ["id":id.stringValue] as NSDictionary
        
        
        self.post(endPoint:kTwitterPOSTFavoritesDestroy, parameters:parameters, success: { (response:Any) in
            
            print(response)
            
            let updatedTweet = Tweet(withJson: response as! [String : Any])
            success(updatedTweet)
            
        }) { (error:Error?) in
            print(error!.localizedDescription)
            failure(error)
        }
    }

    // MARK: POST Retweet
    public func postRetweet(tweet:Tweet, success: @escaping (Tweet)->(), failure: @escaping (Error?)->()) {
        let urlString = urlStringToRetweet(tweet: tweet)
        self.post(endPoint:urlString, parameters:nil, success: { (response:Any) in
            
            print(response)
            let newTweet = Tweet(withJson: response as! [String : Any])
            success(newTweet)
            
        }) { (error:Error?) in
            print(error!.localizedDescription)
            failure(error)
        }
    }
    
    
    // MARK: POST Direct Message
    public func postDirectMessageTo(receiver:TwittsterUser, withText text:String, success: @escaping (Any)->(), failure: @escaping (Error?)->()) {
        let screenName = NSMutableString(string: receiver.screenName)
        screenName.deleteCharacters(in: NSRange(location: 0,length: 1))
        
        let parameter = ["screen_name":screenName, "text":text] as NSDictionary
        
        self.post(endPoint:kDirectMessage, parameters:parameter, success: { (response:Any) in
            
            print(response)
            success(response)
            
        }) { (error:Error?) in
            print(error!.localizedDescription)
            failure(error)
        }
    }
    
    // MARK: POST Direct Message
    public func postReplyMessageTo(replyToTweet:Tweet, withText text:String, success: @escaping (Tweet)->(), failure: @escaping (Error?)->()) {
        let parameter = ["status":text,
                         "in_reply_to_status_id":replyToTweet.id.stringValue] as NSDictionary
        
        self.post(endPoint:kTwitterPOSTTweet, parameters:parameter, success: { (response:Any) in
            
            print(response)
            let updatedTweet = Tweet(withJson: response as! [String : Any])
            success(updatedTweet)
            
        }) { (error:Error?) in
            print(error!.localizedDescription)
            failure(error)
        }
    }
    
    // MARK: POST Tweet Message
    public func postTweet(withText text:String, success: @escaping (Tweet)->(), failure: @escaping (Error?)->()) {

        let parameter = ["status":text] as NSDictionary
        
        self.post(endPoint:kTwitterPOSTTweet, parameters:parameter, success: { (response:Any) in
            
            let newTweet = Tweet(withJson: response as! [String : Any])
            print(response)
            success(newTweet)
            
        }) { (error:Error?) in
            print(error!.localizedDescription)
            failure(error)
        }
    }
    
    
    // MARK: - Local timeline entry and search

    func addNewTweet(tweet:Tweet) {
        self.timeline?.insert(tweet, at: 0)
    }
    
    func find(tweet:Tweet)->Tweet {
        return self.find(tweet: tweet, inModel: self.timeline!)
    }
    
    //Find the tweet with the same id in the Server Model
    func find(tweet:Tweet, inModel model:[Tweet])->Tweet {
        
        let index = findIndexOf(tweet: tweet, inModel: self.timeline!)
        
        print("PassedTweet \(tweet.debugDescription)")
        print("FoundTweet \(model[index].debugDescription)")
        
        return model[index]
    }
    
    func findIndexOf(tweet:Tweet, inModel model:[Tweet])->Int {
        let tweetIDInt = tweet.id.intValue
        
        let index = model.index(where: { (eachTweet) -> Bool in
            if eachTweet.id.intValue == tweetIDInt {
                return true
            }
            else {
                return false
            }
        })
        
        return index!
    }
    
    func updateTweetInTimeline(withTweet tweet:Tweet) {
        
        let index = self.findIndexOf(tweet: tweet, inModel: self.timeline!)
        self.timeline?[index] = tweet
    }
    
    func updateTweetInMentions(withTweet tweet:Tweet) {
        
        let index = self.findIndexOf(tweet: tweet, inModel: self.mentionsTimeline!)
        self.mentionsTimeline?[index] = tweet
    }

    
    
}


















