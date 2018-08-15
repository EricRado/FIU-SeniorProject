//
//  Activity.swift
//  LifeManagementApp
//
//  Created by Eric Rado on 10/6/17.
//  Copyright © 2017 SeniorProject. All rights reserved.
//

import Foundation
import Firebase

struct Activity{
    var name: String
    var activityScore: String
    var actualPoints: String
    var targetPoints: String
    var sprintDailyPoints: String
    var categoryId: String
    var userId: String
    
    init(name: String, activityScore: String, actualPoints: String, targetPoints: String,
         sprintDailyPoints: String, categoryId: String, userId: String){
        self.name = name
        self.activityScore = activityScore
        self.actualPoints = actualPoints
        self.targetPoints = targetPoints
        self.sprintDailyPoints = sprintDailyPoints
        self.categoryId = categoryId
        self.userId = userId
    }
    
    init?(snapshot: DataSnapshot){
        guard let dict = snapshot.value as? [String: String] else {return nil}
        
        guard let name = dict["name"] else {return nil}
        guard let activityScore = dict["activityScore"] else {return nil}
        guard let actualPoints = dict["actualPoints"] else {return nil}
        guard let targetPoints = dict["targetPoints"] else {return nil}
        guard let sprintDailyPoints = dict["sprintDailyPoints"] else {return nil}
        guard let categoryId = dict["categoryId"] else {return nil}
        guard let userId = dict["userId"] else {return nil}
        
        self.name = name
        self.activityScore = activityScore
        self.actualPoints = actualPoints
        self.targetPoints = targetPoints
        self.sprintDailyPoints = sprintDailyPoints
        self.categoryId = categoryId
        self.userId = userId
    }
    
    init(){
        self.name = ""
        self.activityScore = ""
        self.actualPoints = ""
        self.targetPoints = ""
        self.sprintDailyPoints = ""
        self.categoryId = ""
        self.userId = ""
    }
    
    init(name: String, categoryId: String, userId: String){
        self.name = name
        self.activityScore = "0"
        self.actualPoints = "0"
        self.targetPoints = "0"
        self.sprintDailyPoints = "0"
        self.categoryId = categoryId
        self.userId = userId
    }
    
    func toAnyObject() -> [AnyHashable: Any]{
        return ["name":name, "activityScore":activityScore,"actualPoints":actualPoints, "targetPoints":targetPoints, "sprintDailyPoints":sprintDailyPoints, "categoryId":categoryId, "userId":userId]
    }
}
