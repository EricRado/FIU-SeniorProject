//
//  ActivityViewModel.swift
//  LifeManagementApp
//
//  Created by Eric Rado on 7/16/18.
//  Copyright © 2018 SeniorProject. All rights reserved.
//

import Foundation
import Firebase

struct ActivityViewModel {
    private let activity: Activity
    private let sprint: Sprint
    private let dbRef = Database.database()
        .reference(fromURL: "https://life-management-v2.firebaseio.com/")
    
    public init(activity: Activity, sprint: Sprint) {
        self.activity = activity
        self.sprint = sprint
        
        self.actualPoints = activity.actualPoints
        self.sprintDailyPoints = activity.sprintDailyPoints
    }
    
    public var targetPoints: String {
        return activity.targetPoints
    }
    
    public var actualPoints: String
    
    public var sprintDailyPoints: String
    
    // goal percentage actual/target for UILabel to display
    public var goalPercentageStr: String? {
        var goalPercentageString: String
        if let actualScore = Double(activity.actualPoints),
            let targetScore = Double(activity.targetPoints) {
            
            let goalScore = (actualScore / targetScore) * 100
            let goalScoreInt = Int(round(goalScore))
            
            if goalScoreInt >= 100 {
                goalPercentageString = "100%"
            } else {
                goalPercentageString = "\(String(goalScoreInt))%"
            }
        }else {
            print("Scores were not set properly")
            return nil
        }
        return goalPercentageString
    }
    
    // goal percentage = actual/target for calculating average emotion score
    public var goalPercentage: Double? {
        var goalPercentage: Double
        if let actualScore = Double(activity.actualPoints),
            let targetScore = Double(activity.targetPoints) {
            
            goalPercentage = (actualScore / targetScore) * 100
            
            if goalPercentage >= 100.0 {
                goalPercentage = 100.0
            }
        } else {
            print("Scores were not set properly")
            return nil
        }
        return goalPercentage
    }
    
    mutating func updateActualScoreAndDailyPoints(activityId: String, dailyPointsModifiedIndex: Int) {
        // update daily points
        let index = self.sprintDailyPoints.index(self.sprintDailyPoints.startIndex,
                                            offsetBy: dailyPointsModifiedIndex)
        let value = self.sprintDailyPoints[index]
        
        // modify the daily points string according to the value found
        if value == "1" {
            self.sprintDailyPoints = self.sprintDailyPoints
                .replace(dailyPointsModifiedIndex, "0")
        } else {
            self.sprintDailyPoints = self.sprintDailyPoints
                .replace(dailyPointsModifiedIndex, "1")
        }
        
        print("sprintDailyPoints : \(self.sprintDailyPoints)")
        
        // update the new sprint daily points to the database
        let activityRef = dbRef.child("Activities/\(activityId)")
        activityRef.updateChildValues(["actualPoints": self.actualPoints, "sprintDailyPoints": self.sprintDailyPoints]) { (error, dbRef) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Updated sprint daily points and actual score successfully")
            }
        }
    }
    
}













