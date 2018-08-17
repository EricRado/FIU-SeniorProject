//
//  Sprint.swift
//  LifeManagementApp
//
//  Created by Eric Rado on 10/6/17.
//  Copyright © 2017 SeniorProject. All rights reserved.
//

import Foundation
import Firebase

struct Sprint{
    var numberOfWeeks: String
    var sprintOverallScore: String
    var startingDate: String 
    var endingDate: String
    var sprintActivityId1: String
    var sprintActivityId2: String
    var goal1: String
    var goal2: String
    var goal3: String
    var goal4: String
    var categoryId: String
    let timestamp: Int64
    
    init(numberOfWeeks: String, sprintOverallScore: String, startingDate: String, endingDate: String,
         sprintActivityId1: String, sprintActivityId2: String, goal1: String, goal2: String,
         goal3: String, goal4: String, categoryId: String, timestamp: Int64){
        self.numberOfWeeks = numberOfWeeks
        self.sprintOverallScore = sprintOverallScore
        self.startingDate = startingDate
        self.endingDate = endingDate
        self.sprintActivityId1 = sprintActivityId1
        self.sprintActivityId2 = sprintActivityId2
        self.goal1 = goal1
        self.goal2 = goal2
        self.goal3 = goal3
        self.goal4 = goal4
        self.categoryId = categoryId
        self.timestamp = timestamp
    }
    
    init?(snapshot: DataSnapshot){
        guard let dict = snapshot.value as? [String: String] else {return nil}
        
        guard let endingDate = dict["endingDate"] else {return nil}
        guard let startingDate = dict["startingDate"] else {return nil}
        guard let numberOfWeeks = dict["numberOfWeeks"] else {return nil}
        guard let sprintActivityId1 = dict["sprintActivityId1"] else {return nil}
        guard let sprintActivityId2 = dict["sprintActivityId2"] else {return nil}
        guard let sprintOverallScore = dict["sprintOverallScore"] else {return nil}
        guard let goal1 = dict["goal1"] else {return nil}
        guard let goal2 = dict["goal2"] else {return nil}
        guard let goal3 = dict["goal3"] else {return nil}
        guard let goal4 = dict["goal4"] else {return nil}
        guard let categoryId = dict["categoryId"] else {return nil}
        guard let timestamp = dict["timestamp"] else {return nil}
        
        self.numberOfWeeks = numberOfWeeks
        self.sprintOverallScore = sprintOverallScore
        self.startingDate = startingDate
        self.endingDate = endingDate
        self.sprintActivityId1 = sprintActivityId1
        self.sprintActivityId2 = sprintActivityId2
        self.goal1 = goal1
        self.goal2 = goal2
        self.goal3 = goal3
        self.goal4 = goal4
        self.categoryId = categoryId
        self.timestamp = Int64(timestamp) ?? 0
        
    }
    
    init(){
        self.numberOfWeeks = ""
        self.sprintOverallScore = ""
        self.startingDate = ""
        self.endingDate = ""
        self.sprintActivityId1 = ""
        self.sprintActivityId2 = ""
        self.goal1 = ""
        self.goal2 = ""
        self.goal3 = ""
        self.goal4 = ""
        self.categoryId = ""
        self.timestamp = 0
    }
    
    init(categoryId: String, sprintActivityId1: String, sprintActivityId2: String){
        self.numberOfWeeks = "0"
        self.sprintOverallScore = "0.0"
        self.startingDate = ""
        self.endingDate = ""
        self.sprintActivityId1 = sprintActivityId1
        self.sprintActivityId2 = sprintActivityId2
        self.goal1 = ""
        self.goal2 = ""
        self.goal3 = ""
        self.goal4 = ""
        self.categoryId = categoryId
        self.timestamp = 0
    }
    
    func toAnyObject() -> [AnyHashable: Any]{
        return ["numberOfWeeks":numberOfWeeks, "sprintOverallScore":sprintOverallScore, "startingDate":startingDate, "endingDate":endingDate, "sprintActivityId1":sprintActivityId1, "sprintActivityId2":sprintActivityId2, "goal1":goal1, "goal2":goal2, "goal3":goal3, "goal4":goal4, "categoryId": categoryId]
            as [AnyHashable: Any]
    }
}
