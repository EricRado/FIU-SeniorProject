//
//  Message.swift
//  LifeManagementApp
//
//  Created by Eric Rado on 5/4/18.
//  Copyright © 2018 SeniorProject. All rights reserved.
//

import Foundation
import Firebase

struct Message {
    var text: String?
    var username: String
    var timestamp: String
    
    init(text: String, username: String) {
        self.text = text
        self.username = username
        self.timestamp = ""
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String: String] else { return nil}
        guard let text = dict["text"] else {return nil}
        guard let username = dict["username"] else{ return nil}
        guard let timestamp = dict["timestamp"] else{ return nil}
        
        self.text = text
        self.username = username
        self.timestamp = timestamp
    }
    
    func toAnyObject() -> [AnyHashable: Any] {
        return ["text": text!, "username": username, "timestamp": timestamp]
    }
}






