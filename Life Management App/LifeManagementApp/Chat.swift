//
//  Chat.swift
//  LifeManagementApp
//
//  Created by Eric Rado on 11/25/17.
//  Copyright © 2017 SeniorProject. All rights reserved.
//

import Foundation
import Firebase

struct Chat{
    var coachId: String
    var userId: String
    var lastMessage: String
    
    init(coachId: String, userId: String){
        self.coachId = coachId
        self.userId = userId
        self.lastMessage = ""
    }
    
    init?(snapshot: DataSnapshot){
        guard let dict = snapshot.value as? [String: String] else{ return nil}
        guard let coachId = dict["coachId"] else{ return nil}
        guard let userId = dict["userId"] else{ return nil}
        guard let lastMessage = dict["lastMessage"] else{ return nil}
        
        self.coachId = coachId
        self.userId = userId
        self.lastMessage = lastMessage
    }
    
    init(){
        self.coachId = ""
        self.userId = ""
        self.lastMessage = ""
    }
    
    func toAnyObject() -> [AnyHashable: Any]{
        return ["coachId": coachId, "userId": userId, "lastMessage": lastMessage]
    }
}
