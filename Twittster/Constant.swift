//
//  Constant.swift
//  Twittster
//
//  Created by Developer on 10/27/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import Foundation


let ktest = "test"


// MARK: - TWitter API Auth info
let kTwitterURLString = "https://api.twitter.com"

let kTwitterConsumerKey = "kNekwP6ccu5yMNuz6WFDSHUpk"
let kTwitterConsumerSecret = "6sNwadljIQR4Sq9unOO7Z91olwS2OKcnNAEkwnWfPapKyULuZ7"

let kTwitterRequestTokenPath = "/oauth/request_token"
let kTwitterAuthPath = "/oauth/authorize"
let kTwitterAccessTokenPath = "oauth/access_token"
let kTWitterCallBackURL = URL(string: "twittster://oauth")!

func authURL(requestToken:String)->URL{
    var authURLComponents = URLComponents(string: kTwitterURLString + kTwitterAuthPath)
    authURLComponents?.queryItems = [URLQueryItem(name: "oauth_token", value: requestToken)]
    
    return authURLComponents?.url ?? URL(string:"")!
}

// MARK: - Twitter API
let kTwitterGETCredentials = "/1.1/account/verify_credentials.json"
