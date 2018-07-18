//
//  Test3VC.swift
//  LifeManagementApp
//
//  Created by Eric Rado on 7/18/18.
//  Copyright © 2018 SeniorProject. All rights reserved.
//

import UIKit

class Test3VC: EmotionVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        emotionChoice = "Contribution"
        self.emotionLabel.text = "Contrib. Score"
        
        let choiceStr = "\(emotionChoice)Activities"
        self.imgUrlDbRef = dbRef.child("ActivityImgs/\(choiceStr)")
        getCategoryKey(userId: delegate.user.id)
    }

}
