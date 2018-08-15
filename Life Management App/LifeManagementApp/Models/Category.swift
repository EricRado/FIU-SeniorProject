//
//  Category.swift
//  LifeManagementApp
//
//  Created by Eric Rado on 9/17/17.
//  Copyright © 2017 SeniorProject. All rights reserved.
//

import Foundation

struct Category{
    
    var joySprints: [Sprint]
    var passionSprints: [Sprint]
    var contributionSprints: [Sprint]
    var userId: String
    
    init(userId: String, joySprints: [Sprint], passionSprints: [Sprint], contributionSprints: [Sprint]){
        self.userId = userId
        self.joySprints = joySprints
        self.passionSprints = passionSprints
        self.contributionSprints = contributionSprints
    }
    
    init(){
        self.userId = ""
        self.joySprints = [Sprint]()
        self.passionSprints = [Sprint]()
        self.contributionSprints = [Sprint]()
    }
    
}
