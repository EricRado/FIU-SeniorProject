//
//  EmotionVC.swift
//  LifeManagementApp
//
//  Created by Eric Rado on 7/15/18.
//  Copyright © 2018 SeniorProject. All rights reserved.
//

import UIKit

class EmotionVC: UIViewController {
    
    // :- MARK IBOutlet Instances
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    
    @IBOutlet weak var a1GoalScoreLabel: UILabel!
    @IBOutlet weak var a1ActualScoreLabel: UILabel!
    @IBOutlet weak var a1ScorePercentageLabel: UILabel!
    
    @IBOutlet weak var a2GoalScoreLabel: UILabel!
    @IBOutlet weak var a2ActualScoreLabel: UILabel!
    @IBOutlet weak var a2ScorePercentageLabel: UILabel!
    
    
    @IBOutlet weak var a1Image: UIImageView!
    @IBOutlet weak var a2Image: UIImageView!
    
    @IBOutlet weak var emotionLabel: UILabel!
    
    @IBOutlet weak var emotionScorePercentageLabel: UILabel!
    @IBOutlet weak var overallScorePercentageLabel: UILabel!
    
    @IBOutlet weak var emotionScore: KDCircularProgress!
    @IBOutlet weak var overallScore: KDCircularProgress!
    
    
    @IBOutlet weak var question1TextField: UITextField!
    @IBOutlet weak var question2TextField: UITextField!
    @IBOutlet weak var question3TextField: UITextField!
    @IBOutlet weak var question4TextField: UITextField!
    
    @IBOutlet weak var submitBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()

        // Do any additional setup after loading the view.
    }

}
