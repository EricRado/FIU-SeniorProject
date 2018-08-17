//
//  PassionVC.swift
//  LifeManagementApp
//
//  Created by Eric Rado on 10/30/17.
//  Copyright © 2017 SeniorProject. All rights reserved.
//

import UIKit
import Firebase

class PassionVC: EmotionVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emotionChoice = "Passion"
        self.emotionLabel.text = "Passion Score"
        
        // set URL to download activity images
        let choiceStr = "\(emotionChoice)Activities"
        self.imgUrlDbRef = dbRef.child("ActivityImgs/\(choiceStr)")
        
        // retrieve most recent passion sprint
        getCategoryKey(userId: delegate.user.id)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("view is about to appear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("view is disappearing")
    }

}










