//
//  Coach.swift
//  LifeManagementApp
//
//  Created by Eric Rado on 5/4/18.
//  Copyright © 2018 SeniorProject. All rights reserved.
//

import Foundation
import Firebase

struct Coach {
    var username: String
    var password: String
    var firstName: String
    var lastName: String
    var email: String
    var id: String
    var successRating: String
    var skills: String
    var imgURL: String
    
    init(username: String, password: String, id: String, email: String, firstName: String, lastName: String, successRating: String,
         skills: String){
        self.id = id
        self.username = username
        self.password = password
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.successRating = "80"
        self.skills = skills
        self.imgURL = ""
    }
    
    init?(snapshot: DataSnapshot){
        guard let dict = snapshot.value as? [String: String] else {return nil}
        guard let id = dict["id"] else {return nil}
        guard let username = dict["username"] else {return nil}
        guard let password = dict["password"] else {return nil}
        guard let email = dict["email"] else {return nil}
        guard let firstName = dict["firstName"] else {return nil}
        guard let lastName = dict["lastName"] else {return nil}
        guard let successRating = dict["successRating"] else {return nil}
        guard let skills = dict["skills"] else {return nil}
        guard let imgURL = dict["imgURL"] else {return nil}
        
        self.id = id
        self.username = username
        self.password = password
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.successRating = successRating
        self.skills = skills
        self.imgURL = imgURL
    }
    
    init(){
        self.id = ""
        self.username = ""
        self.password = ""
        self.email = ""
        self.firstName = ""
        self.lastName = ""
        self.successRating = ""
        self.skills = ""
        self.imgURL = ""
    }
    
    func toAnyObject() -> [AnyHashable:Any]{
        return ["id": id, "username": username, "password": password, "email": email, "firstName": firstName, "lastName": lastName,
                "successRating": successRating, "skills": skills]
    }
}
