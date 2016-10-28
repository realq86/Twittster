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
    
    var loginSuccessHandler:(()->())?
    var loginFailureHandler:(()->())?
    
    public func login(success:@escaping ()->(),failure:()->()) {
        
        self.loginSuccessHandler = success
        
        weak var weakSelf = self
        manager.fetchRequestToken(withPath: kTwitterRequestTokenPath, method: "GET", callbackURL: kTWitterCallBackURL, scope: nil,success: { (requestToken:BDBOAuth1Credential?) in
                        print("FetchRquestToken: Success Token = \(requestToken?.token)")
                        weakSelf?.openAuthURLWithToken(requestToken?.token)
                    }) {(error:Error?) in
                        print("FetchRequestToken: Error = \(error)")
                        weakSelf?.loginFailureHandler?()
        }
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
                weakSelf?.loginSuccessHandler?()
            
            }, failure: { (error:Error?) in
            
                print("FetchAccessToken Fail \(error)")
                weakSelf?.loginFailureHandler?()
        
        })
        
        
    }
    
    public func getCredentials() {
        manager.get(kTwitterGETCredentials, parameters: nil, progress: nil,
            success: { (task:URLSessionDataTask, response:Any?) in
                            
                print("GET Credentials: \(response)")
                
            }, failure: { (tast:URLSessionDataTask?, error:Error) in
        })
    }
    

}
