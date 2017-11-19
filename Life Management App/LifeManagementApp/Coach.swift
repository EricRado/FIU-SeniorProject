//
//  Coach.swift
//  LifeManagementApp
//
//  Created by Eric Rado on 11/19/17.
//  Copyright © 2017 SeniorProject. All rights reserved.
//

import Foundation
import Firebase

struct Coach{
    var firstName: String
    var lastName: String
    var email: String
    var id: String
    var rating: String
    var skills: String
    
    init(id: String, email: String, firstName: String, lastName: String, rating: String,
         skills: String){
        self.id = id
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.rating = rating
        self.skills = skills
    }
    
    init?(snapshot: DataSnapshot){
        guard let dict = snapshot.value as? [String: String] else {return nil}
        guard let id = dict["id"] else {return nil}
        guard let email = dict["email"] else {return nil}
        guard let firstName = dict["firstName"] else {return nil}
        guard let lastName = dict["lastName"] else {return nil}
        guard let rating = dict["rating"] else {return nil}
        guard let skills = dict["skills"] else {return nil}
        
        self.id = id
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.rating = rating
        self.skills = skills
    }
    
    init(){
        self.id = ""
        self.email = ""
        self.firstName = ""
        self.lastName = ""
        self.rating = ""
        self.skills = ""
    }
    
    func toAnyObject() -> [AnyHashable:Any]{
        return ["id": id, "email": email, "firstName": firstName, "lastName": lastName,
            "rating": rating, "skills": skills]
    }
    
}
