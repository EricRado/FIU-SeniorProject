//
//  ContributionVC.swift
//  LifeManagementApp
//
//  Created by Eric Rado on 10/30/17.
//  Copyright © 2017 SeniorProject. All rights reserved.
//

import UIKit
import Firebase

class ContributionVC: EmotionVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emotionChoice = "Contribution"
        self.emotionLabel.text = "Contrib. Score"
        
        // set URL to download activity images
        let choiceStr = "\(emotionChoice)Activities"
        self.imgUrlDbRef = dbRef.child("ActivityImgs/\(choiceStr)")
        
        // retrieve most recent contribution sprint
        getCategoryKey(userId: delegate.user.id)
    }
    
}








