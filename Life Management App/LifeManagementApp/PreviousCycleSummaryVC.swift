//
//  PreviousCycleSummaryVC.swift
//  LifeManagementApp
//
//  Created by Eric Rado on 11/9/17.
//  Copyright © 2017 SeniorProject. All rights reserved.
//

import UIKit

class PreviousCycleSummaryVC: UIViewController {
    
    var joyActivity1 = Activity()
    var joyActivity2 = Activity()
    var passionActivity1 = Activity()
    var passionActivity2 = Activity()
    var contributionActivity1 = Activity()
    var contributionActivity2 = Activity()
    
    var sprint = Sprint()
    var delegate = UIApplication.shared.delegate as! AppDelegate
    
    // labels for goal and actual scores
    @IBOutlet weak var joyActivityScore1Label: UILabel!
    @IBOutlet weak var joyActivityScore2Label: UILabel!
    
    @IBOutlet weak var joyActivityGoalScore1Label: UILabel!
    @IBOutlet weak var joyActivityGoalScore2Label: UILabel!
    
    @IBOutlet weak var passionActivityScore1Label: UILabel!
    @IBOutlet weak var passionActivityScore2Label: UILabel!
    
    
    @IBOutlet weak var passionActivityGoalScore1Label: UILabel!
    @IBOutlet weak var passionActivityGoalScore2Label: UILabel!
    
    
    @IBOutlet weak var contribActivityScore1Label: UILabel!
    @IBOutlet weak var contribActivityScore2Label: UILabel!
    
    
    @IBOutlet weak var contribActivityGoalScore1Label: UILabel!
    @IBOutlet weak var contribActivityGoalScore2Label: UILabel!
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadLabels()
    }
    
    func loadLabels(){
        joyActivityScore1Label.text = joyActivity1.actualPoints
        joyActivityScore2Label.text = joyActivity2.actualPoints
        
        joyActivityGoalScore1Label.text = joyActivity1.targetPoints
        joyActivityGoalScore2Label.text = joyActivity2.targetPoints
        
        passionActivityScore1Label.text = passionActivity1.actualPoints
        passionActivityScore2Label.text = passionActivity2.actualPoints
        
        passionActivityGoalScore1Label.text = passionActivity1.targetPoints
        passionActivityGoalScore2Label.text = passionActivity2.targetPoints
        
        contribActivityScore1Label.text = contributionActivity1.actualPoints
        contribActivityScore2Label.text = contributionActivity2.actualPoints
        
        contribActivityGoalScore1Label.text = contributionActivity1.targetPoints
        contribActivityGoalScore2Label.text = contributionActivity2.targetPoints
    }
    
    

}
