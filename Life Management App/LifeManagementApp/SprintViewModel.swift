//
//  SprintViewModel.swift
//  LifeManagementApp
//
//  Created by Eric Rado on 7/16/18.
//  Copyright © 2018 SeniorProject. All rights reserved.
//

import Foundation

struct SprintViewModel {
    private let sprint: Sprint
    
    public init(sprint: Sprint) {
        self.sprint = sprint
    }
    
    public var goal1: String {
        return sprint.goal1
    }
    
    public var goal2: String {
        return sprint.goal2
    }
    
    public var goal3: String {
        return sprint.goal3
    }
    
    public var goal4: String {
        return sprint.goal4
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
}
