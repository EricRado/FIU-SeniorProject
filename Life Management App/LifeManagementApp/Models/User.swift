//
//  User.swift
//  LifeManagementApp
//
//  Created by Eric Rado on 9/17/17.
//  Copyright © 2017 SeniorProject. All rights reserved.
//

import Foundation
import Firebase

// Change to a singleton
struct User{
    
    var id: String
    var email: String
    var username: String
    var firstName: String
    var lastName : String
    var password: String
    var dob: String
    var imgURL: String?
    let adminFlag: Bool
    let coachFlag: Bool
    
    
    init(id: String, email: String, username: String, firstName: String, lastName: String,
         dob: String,password: String,adminFlag: Bool, coachFlag: Bool, imgURL: String){
        
        self.id = id
        self.email = email
        self.username = username
        self.password = password
        self.firstName = firstName
        self.lastName = lastName
        self.dob = dob
        self.imgURL = imgURL
        self.adminFlag = adminFlagDo
        self.coachFlag = coachFlag
    }
    
    init?(snapshot: DataSnapshot){
        guard let dict = snapshot.value as? [String:String] else { return nil }
        guard let id = dict["id"] else {return nil}
        guard let email = dict["email"] else { return nil }
        guard let username = dict["username"] else { return nil }
        guard let password = dict["password"] else { return nil }
        guard let firstName = dict["firstName"] else { return nil }
        guard let lastName = dict["lastName"] else { return nil }
        guard let dob = dict["dob"] else { return nil }
        guard let imgURL = dict["imgURL"] else { return nil }
        
        self.id = id
        self.email = email
        self.username = username
        self.password = password
        self.firstName = firstName
        self.lastName = lastName
        self.dob = dob
        self.imgURL = imgURL
        self.adminFlag = false
        self.coachFlag = false
        
    }
    
    init(){
        self.id = ""
        self.email = ""
        self.username = ""
        self.password = ""
        self.firstName = ""
        self.lastName = ""
        self.dob = ""
        self.imgURL = ""
        self.adminFlag = false
        self.coachFlag = false
    }
    
    func toAnyObject() -> [AnyHashable:Any]{
        return ["id":id,"email":email, "username":username,"firstName":firstName, "lastName":lastName,
                "dob":dob, "password":password, "adminFlag": adminFlag, "coachFlag": coachFlag, "imgURL": ""] as [AnyHashable:Any]
    }
}
