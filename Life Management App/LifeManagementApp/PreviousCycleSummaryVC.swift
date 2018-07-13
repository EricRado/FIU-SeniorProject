//
//  PreviousCycleSummaryVC.swift
//  LifeManagementApp
//
//  Created by Eric Rado on 11/9/17.
//  Copyright © 2017 SeniorProject. All rights reserved.
//

import UIKit

class PreviousCycleSummaryVC: UIViewController {
    
    // MARK: - ViewController's Variables
    
    var joyActivity1 = Activity()
    var joyActivity2 = Activity()
    var passionActivity1 = Activity()
    var passionActivity2 = Activity()
    var contributionActivity1 = Activity()
    var contributionActivity2 = Activity()
    
    var sprint = Sprint()
    var delegate = UIApplication.shared.delegate as! AppDelegate
    
    // MARK: - ViewController's IBOutlet Variables
    
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
    
    // images for each activity
    @IBOutlet weak var joyActivity1Image: UIImageView!
    @IBOutlet weak var joyActivity2Image: UIImageView!
    
    @IBOutlet weak var passionActivity1Image: UIImageView!
    @IBOutlet weak var passionActivity2Image: UIImageView!
    
    @IBOutlet weak var contributionActivity1Image: UIImageView!
    @IBOutlet weak var contributionActivity2Image: UIImageView!
    
    
    // label for date
    @IBOutlet weak var sprintDateLabel: UILabel!
    
    // KDCircularProgress for each category
    @IBOutlet weak var joyOverallScore: KDCircularProgress!
    @IBOutlet weak var passionOverallScore: KDCircularProgress!
    @IBOutlet weak var contributionOverallScore: KDCircularProgress!
    
    // label for overall scores
    @IBOutlet weak var joyOverallScoreLabel: UILabel!
    @IBOutlet weak var passionOverallScoreLabel: UILabel!
    @IBOutlet weak var contributionOverallScoreLabel: UILabel!
    
    // MARK: - ViewController's Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadLabels()
        
        loadImages(name1: joyActivity1.name, name2: joyActivity2.name, option: "Joy")
        loadImages(name1: passionActivity1.name, name2: passionActivity2.name, option: "Passion")
        loadImages(name1: contributionActivity1.name, name2: contributionActivity2.name,option: "Contribution")
        
        setScorePercentage(target1: joyActivity1.targetPoints, actual1: joyActivity1.actualPoints, target2: joyActivity2.targetPoints, actual2: joyActivity2.actualPoints, option: "Joy")
        setScorePercentage(target1: passionActivity1.targetPoints, actual1: passionActivity1.actualPoints, target2: passionActivity2.targetPoints, actual2: passionActivity2.actualPoints, option: "Passion")
        setScorePercentage(target1: contributionActivity1.targetPoints, actual1: contributionActivity1.actualPoints, target2: contributionActivity2.targetPoints, actual2: contributionActivity2.actualPoints, option: "Contribution")
    }
    
    // MARK: - Setup UIView's visual display methods
    
    // setup activity label texts with the sprint selected in the previous screen
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
        
        sprintDateLabel.text = setDates(startDay: sprint.startingDate, endDay: sprint.endingDate)
    }
    
    // set date text labels from the sprint selected in the previous screen
    func setDates(startDay: String, endDay: String) -> String{
        let dateFmt = DateFormatter()
        
        // convert date strings to  date objects 
        dateFmt.dateFormat = "MMddyyyy"
        let startDate = dateFmt.date(from: startDay)
        let endDate = dateFmt.date(from: endDay)
        
        dateFmt.dateFormat = "MM/dd/yy"
        let startDateStr = dateFmt.string(from: startDate!)
        let endDateStr = dateFmt.string(from: endDate!)
        
        return "\(startDateStr) - \(endDateStr)"
    }
    
    // load activity images from the sprint selected in the previous screen
    func loadImages(name1: String, name2: String, option: String){
        //retrieve the images for the specific category for the sprint
        if(option == "Joy"){
            // find joy images
            for image in self.delegate.joyImages{
                if(image.name == name1){
                    joyActivity1Image.image = image.uiImage.image
                    turnImageToCircle(picture: joyActivity1Image)
                }else if(image.name == name2){
                    joyActivity2Image.image = image.uiImage.image
                    turnImageToCircle(picture: joyActivity2Image)
                }
            }
        }else if(option == "Passion"){
            // find passion images
            for image in self.delegate.passionImages{
                if(image.name == name1){
                    passionActivity1Image.image = image.uiImage.image
                    turnImageToCircle(picture: passionActivity1Image)
                }else if(image.name == name2){
                    passionActivity2Image.image = image.uiImage.image
                    turnImageToCircle(picture: passionActivity2Image)
                }
            }
        }else{
            // find contribution images
            for image in self.delegate.contributionImages{
                if(image.name == name1){
                    contributionActivity1Image.image = image.uiImage.image
                    turnImageToCircle(picture: contributionActivity1Image)
                }else if(image.name == name2){
                    contributionActivity2Image.image = image.uiImage.image
                    turnImageToCircle(picture: contributionActivity2Image)
                }
            }
        }
    }
    
    // display the scores and percentages for all activites based on activity type
    func setScorePercentage(target1: String, actual1: String, target2: String, actual2: String, option: String){
        let avgScore: String
        var score: Double = ((Double(actual1)! / Double(target1)!) + (Double(actual2)! / Double(target2)!))/2
        score = score*100
        
        avgScore = String(format:"%.01f%"+"%", score)
        
        if(option == "Joy"){
            joyOverallScoreLabel.text = avgScore
            joyOverallScore.angle = score * 3.6
        }else if(option == "Passion"){
            passionOverallScoreLabel.text = avgScore
            passionOverallScore.angle = score * 3.6
        }else{
            contributionOverallScoreLabel.text = avgScore
            contributionOverallScore.angle = score * 3.6
        }
    }
    
    func turnImageToCircle(picture: UIImageView){
        picture.layer.cornerRadius = picture.frame.size.width / 2
        picture.clipsToBounds = true
        self.view.layoutIfNeeded()
    }

}
