//
//  Test2VC.swift
//  LifeManagementApp
//
//  Created by Eric Rado on 7/17/18.
//  Copyright © 2018 SeniorProject. All rights reserved.
//

import UIKit

class Test2VC: EmotionVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        emotionChoice = "Passion"
        self.emotionLabel.text = "Passion Score"
        
        let choiceStr = "\(emotionChoice)Activities"
        self.imgUrlDbRef = dbRef.child("ActivityImgs/\(choiceStr)")
        getCategoryKey(userId: delegate.user.id)
    }

}
