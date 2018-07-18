//
//  JoyVC.swift
//  LifeManagementApp
//
//  Created by Eric Rado on 9/26/17.
//  Copyright © 2017 SeniorProject. All rights reserved.
//

import UIKit
import Firebase


class JoyVC: EmotionVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emotionChoice = "Joy"
        self.emotionLabel.text = "Joy Score"
        
        // set URL to download activity images
        let choiceStr = "\(emotionChoice)Activities"
        self.imgUrlDbRef = dbRef.child("ActivityImgs/\(choiceStr)")
        
        // retrieve most recent joy sprint
        getCategoryKey(userId: delegate.user.id)
    }

}
