//
//  TwittsterUser.swift
//  Twittster
//
//  Created by Developer on 10/28/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit

class TwittsterUser: NSObject {

    var userInJson:NSDictionary?
    
    var name:NSString!
    
    var screenName:String!
    
    var created_at:NSString!
    
    var location:NSString!
    
    var idString:NSString!
    
    var profileImageURLHTTPS:URL?
    
    init(withJson json:NSDictionary) {
        
        self.userInJson = json
        
        self.name = json["name"] as! NSString
        
        self.screenName = "@" + (json["screen_name"] as! String)
        
        self.created_at = json["created_at"] as! NSString
        
        self.location = json["location"] as! NSString
        
        self.idString = json["id_str"] as! NSString
        
        if let urlString = json["profile_image_url_https"] as? NSString {
            self.profileImageURLHTTPS = URL(string: urlString as String)
        }
    }
    
    static var _currentUser:TwittsterUser?
    class var currentUser:TwittsterUser? {
        get {
            
            if self._currentUser == nil {
                let defaults = UserDefaults.standard
                
                var user:TwittsterUser
                
                if let userData = defaults.object(forKey:kCurrentUserKeyInUserDefault) as? Data {
                
                    if let userDictionary = try? JSONSerialization.jsonObject(with: userData, options: []) {
                        
                        if let userDictionary = userDictionary as? NSDictionary {
                            user = TwittsterUser(withJson: userDictionary)
                            return user
                        }
                    }
                }
            }
            
            return self._currentUser

        }
        set(user) {
            
            if let user = user {
                self._currentUser = user
                let defaults = UserDefaults.standard

                do {
                    let json = try JSONSerialization.data(withJSONObject: (user.userInJson)!, options: [])
                    defaults.set(json, forKey: kCurrentUserKeyInUserDefault)

                }
                catch {
                    print("User class JSON ERROR")
                    defaults.set(nil, forKey: kCurrentUserKeyInUserDefault)

                }
            }
        }
    }
    
}
