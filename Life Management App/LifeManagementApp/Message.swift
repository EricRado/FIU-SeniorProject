//
//  Message.swift
//  LifeManagementApp
//
//  Created by Eric Rado on 11/25/17.
//  Copyright © 2017 SeniorProject. All rights reserved.
//

import Foundation
import Firebase

struct Message{
    var message: String
    var username: String
    var timestamp: String
    
    init(message: String, username: String){
        self.message = message
        self.username = username
        self.timestamp = ""
    }
    
    init?(snapshot: DataSnapshot){
        guard let dict = snapshot.value as? [String: String] else{ return nil}
        guard let message = dict["message"] else{ return nil}
        guard let username = dict["username"] else{ return nil}
        guard let timestamp = dict["timestamp"] else{ return nil}
        
        self.message = message
        self.username = username
        self.timestamp = timestamp
    }
    
    init(){
        self.message = ""
        self.username = ""
        self.timestamp = ""
    }
    
    func toAnyObject() -> [AnyHashable: Any]{
        return ["message": message, "username": username, "timestamp": timestamp]
    }
}
