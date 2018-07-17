//
//  SprintViewModel.swift
//  LifeManagementApp
//
//  Created by Eric Rado on 7/16/18.
//  Copyright © 2018 SeniorProject. All rights reserved.
//

import Foundation
import Firebase

struct SprintViewModel {
    private let sprint: Sprint
    private let dbRef = Database.database()
        .reference(fromURL: "https://life-management-v2.firebaseio.com/")
    
    public init(sprint: Sprint) {
        self.sprint = sprint
        
        self.goal1 = sprint.goal1
        self.goal2 = sprint.goal2
        self.goal3 = sprint.goal3
        self.goal4 = sprint.goal4
    }
    
    public var goal1: String
    
    public var goal2: String
    
    public var goal3: String
    
    public var goal4: String
    
    public var activityId1: String {
        return sprint.sprintActivityId1
    }
    
    public var activityId2: String {
        return sprint.sprintActivityId2
    }
    
    public var startingDateFormatted: String {
        return formatStringDate(sprint.startingDate)
    }
    
    public var endingDateFormatted: String {
        return formatStringDate(sprint.endingDate)
    }
    
    private func formatStringDate(_ dateStr: String) -> String {
        let dateFmt = DateFormatter()
        
        // convert date strings to date objects
        dateFmt.dateFormat = "MMddyyyy"
        let date = dateFmt.date(from: dateStr)
        
        // format dates to MM/dd/yyyy
        dateFmt.dateFormat = "MM/dd/yyyy"
        let newDateStr = dateFmt.string(from: date!)
        
        return newDateStr
        
    }
    
    public func updateGoals(emotion: String, sprintId: String, viewController: UIViewController) {
        let emotionStr = "\(emotion)Sprints"

        let updateRef = dbRef.child("Categories/\(sprint.categoryId)/\(emotionStr)/\(sprintId)/")
        updateRef.updateChildValues(
            ["goal1": goal1, "goal2": goal2,"goal3": goal3, "goal4": goal4 ]) { (error, ref) in
                if let error = error {
                    print(error.localizedDescription)
                    viewController.createAlert(titleText: "Update Goals",
                                               messageText: "Save was unsuccessful")
                }
                viewController.createAlert(titleText: "Update Goals",
                                           messageText: "Save was successful")
                
        }
    }
}






















