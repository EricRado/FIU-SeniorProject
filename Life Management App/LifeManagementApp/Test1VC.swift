//
//  Test1VC.swift
//  LifeManagementApp
//
//  Created by Eric Rado on 7/16/18.
//  Copyright © 2018 SeniorProject. All rights reserved.
//

import UIKit

class Test1VC: EmotionVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        emotionChoice = "Joy"
        
        let choiceStr = "\(emotionChoice)Activities"
        self.imgUrlDbRef = dbRef.child("ActivityImgs/\(choiceStr)")
        getCategoryKey(userId: delegate.user.id)
    }



}
