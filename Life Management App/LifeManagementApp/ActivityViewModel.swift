//
//  ActivityViewModel.swift
//  LifeManagementApp
//
//  Created by Eric Rado on 7/16/18.
//  Copyright © 2018 SeniorProject. All rights reserved.
//

import Foundation

struct ActivityViewModel {
    private let activity: Activity
    private let sprint: Sprint
    
    public init(activity: Activity, sprint: Sprint) {
        self.activity = activity
        self.sprint = sprint
    }
    
    public var targetPoints: String {
        return activity.targetPoints
    }
    
    public var actualPoints: String {
        return activity.actualPoints
    }
    
    // goal percentage actual/target for activity
    public var goalPercentage: String {
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
            return ""
        }
        return goalPercentageString
    }
    
}
