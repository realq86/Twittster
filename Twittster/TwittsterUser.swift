//
//  TwittsterUser.swift
//  Twittster
//
//  Created by Developer on 10/28/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit

class TwittsterUser: NSObject {

    var name:String!
    
    var created_at:String!
    
    var location:String!
    
    var idString:String!
    
    init(withJson json:[String:Any]) {
        
        self.name = json["name"] as! String
        
        self.created_at = json["created_at"] as! String
        
        self.location = json["location"] as! String
        
        self.idString = json["id_str"] as! String
    }
    
}
