//
//  SprintSettingsVC.swift
//  LifeManagementApp
//
//  Created by Eric Rado on 10/23/17.
//  Copyright © 2017 SeniorProject. All rights reserved.
//

import UIKit
import Firebase


class SprintSettingsVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    let dbref = Database.database().reference(fromURL: "https://life-management-v2.firebaseio.com/")
    var categoryKey = ""
    var weekList = ["1", "2", "3"]
    var weekChoice = ""
    var joyActivityIds = [String]()
    var passionActivityIds = [String]()
    var contributionActivityIds = [String]()
    var joySprintKey = ""
    var passionSprintKey = ""
    var contributionSprintKey = ""
    
    var startingDate = ""
    var endingDate = ""
    var sprintDailyPoints = ""
    var segueCheck = false
    
    @IBOutlet weak var weekTextField: UITextField!
    @IBOutlet weak var weekOptions: UIPickerView!
    
    // images of all activities
    @IBOutlet weak var joyActivity1Img: UIImageView!
    @IBOutlet weak var joyActivity2Img: UIImageView!
    @IBOutlet weak var passionActivity1Img: UIImageView!
    @IBOutlet weak var passionActivity2Img: UIImageView!
    @IBOutlet weak var contributionActivity1Img: UIImageView!
    @IBOutlet weak var contributionActivity2Img: UIImageView!
    
    @IBOutlet weak var submitBtn: UIButton!
    
    // set the target score text field inputs
    
    @IBOutlet weak var joyTargetScore1: UITextField!
    @IBOutlet weak var joyTargetScore2: UITextField!
    
    @IBOutlet weak var passionTargetScore1: UITextField!
    @IBOutlet weak var passionTargetScore2: UITextField!
    
    @IBOutlet weak var contributionTargetScore1: UITextField!
    @IBOutlet weak var contributionTargetScore2: UITextField!
    
    // set the images for each selected activity
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weekOptions.delegate = self
        weekOptions.dataSource = self
        weekTextField.delegate = self
        categoryKey = delegate.categoryKey
        print("This is the category key (sprint settings) : \(categoryKey)")
        
        weekOptions.isHidden = true
        
        loadImages()
        turnImageToCircle(picture: joyActivity1Img)
        turnImageToCircle(picture: joyActivity2Img)
        turnImageToCircle(picture: passionActivity1Img)
        turnImageToCircle(picture: passionActivity2Img)
        turnImageToCircle(picture: contributionActivity1Img)
        turnImageToCircle(picture: contributionActivity2Img)
        
        setTextFieldEditing()
        
        submitBtn.layer.cornerRadius = 15
        submitBtn.layer.masksToBounds = true
        
        getSprintActivities()
    }
    
    func loadImages(){
        joyActivity1Img.image = delegate.activitySelectedImages[0]
        joyActivity2Img.image = delegate.activitySelectedImages[1]
        
        passionActivity1Img.image = delegate.activitySelectedImages[2]
        passionActivity2Img.image = delegate.activitySelectedImages[3]
        
        contributionActivity1Img.image = delegate.activitySelectedImages[4]
        contributionActivity2Img.image = delegate.activitySelectedImages[5]
    }
    
    func turnImageToCircle(picture: UIImageView){
        picture.layer.cornerRadius = picture.frame.size.width / 2
        picture.clipsToBounds = true
        self.view.layoutIfNeeded()
    }
    
    func setTextFieldEditing(){
        joyTargetScore1.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        joyTargetScore2.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passionTargetScore1.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passionTargetScore2.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        contributionTargetScore1.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        contributionTargetScore2.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        weekTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    func setStartAndEndDate(weeks: String){
        let dateFmt = DateFormatter()
        dateFmt.dateFormat = "MMddyyyy"
        
        let currentDate = Date()
        
        var daysToAdd = 0
        print("week choice : \(weeks)")
        
        // check the user week input to determine when is the sprint ending date and the daily points
        if(weeks == "1"){
            daysToAdd = 6
            sprintDailyPoints = "0000000"
        }else if(weeks == "2"){
            daysToAdd = 13
            sprintDailyPoints = "00000000000000"
            print("Inside TWO weeks")
        }else{
            daysToAdd = 20
            sprintDailyPoints = "000000000000000000000"
        }
        
        var dateComponent = DateComponents()
        
        dateComponent.day = daysToAdd
        
        let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
        
        startingDate = dateFmt.string(from: currentDate)
        endingDate = dateFmt.string(from: futureDate!)
        
        
    }
    
    func getSprintActivities(){
        // set references to the three different categories sprints location
        let joySprintsRef = dbref.child("Categories/\(categoryKey)/JoySprints").queryOrdered(byChild: "numberOfWeeks").queryEqual(toValue: "0")
        let passionSprintsRef = dbref.child("Categories/\(categoryKey)/PassionSprints").queryOrdered(byChild: "numberOfWeeks").queryEqual(toValue: "0")
        let contributionSprintsRef = dbref.child("Categories/\(categoryKey)/ContributionSprints").queryOrdered(byChild: "numberOfWeeks").queryEqual(toValue: "0")
        
        joySprintsRef.observeSingleEvent(of: .value, with: {(snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot]{
                if !child.exists(){
                    print("Snapshot is empty")
                    return
                }
                print("JOY SNAPSHOT...")
                print(snapshot)
                
                // store the key location of the current joy sprint to update starting and ending dates
                self.joySprintKey = child.key
                
                print("JOY SPRINT KEY : \(self.joySprintKey)")
                
                let sprintDict = child.value as? [String: Any]
                
                // store the activity ids for the new sprint into an array of joy activity ids
                if let activityId1 = sprintDict?["sprintActivityId1"] as? String{
                    print("This is joy activity id 1 : \(activityId1)")
                    self.joyActivityIds.append(activityId1)
                }
                if let activityId2 = sprintDict?["sprintActivityId2"] as? String{
                    print("This is joy activity id 1 : \(activityId2)")
                    self.joyActivityIds.append(activityId2)
                }
            }
        }, withCancel: {(error) in
            
            print(error.localizedDescription)
            return
        })
        
        passionSprintsRef.observeSingleEvent(of: .value, with: {(snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot]{
                if !child.exists(){
                    print("Snapshot is empty")
                    return
                }
                print("PASSION SNAPSHOT...")
                print(snapshot)
                
                // store the key location of the current passion sprint to update starting and ending dates
                self.passionSprintKey = child.key
                
                print("PASSSION SPRINT KEY : \(self.passionSprintKey)")
                
                let sprintDict = child.value as? [String: Any]
                
                // store the activity ids for the new sprint into an array of joy activity ids
                if let activityId1 = sprintDict?["sprintActivityId1"] as? String{
                    print("This is passion activity id 1 : \(activityId1)")
                    self.passionActivityIds.append(activityId1)
                }
                if let activityId2 = sprintDict?["sprintActivityId2"] as? String{
                    print("This is passion activity id 2 : \(activityId2)")
                    self.passionActivityIds.append(activityId2)
                }
                
                
            }
        }, withCancel: {(error) in
            
            print(error.localizedDescription)
            return
        })
        
        contributionSprintsRef.observeSingleEvent(of: .value, with: {(snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot]{
                if !child.exists(){
                    print("Snapshot is empty")
                    return
                }
                print("CONTRIBUTION SNAPSHOT...")
                print(snapshot)
                
                // store the key location of the current contribution sprint to update starting and ending dates
                self.contributionSprintKey = child.key
                print("CONTRIBUTION SPRINT KEY : \(self.contributionSprintKey)")
                
                let sprintDict = child.value as? [String: Any]
                
                // store the activity ids for the new sprint into an array of joy activity ids
                if let activityId1 = sprintDict?["sprintActivityId1"] as? String{
                    print("This is contribution activity id 1 : \(activityId1)")
                    self.contributionActivityIds.append(activityId1)
                }
                if let activityId2 = sprintDict?["sprintActivityId2"] as? String{
                    print("This is contribution activity id 2 : \(activityId2)")
                    self.contributionActivityIds.append(activityId2)
                }
            }
        }, withCancel: {(error) in
            
            print(error.localizedDescription)
            return
        })
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return weekList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        self.view.endEditing(true)
        return weekList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        self.weekTextField.text = self.weekList[row]
        self.weekChoice = self.weekList[row]
        self.weekOptions.isHidden = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        if textField == self.weekTextField{
            self.weekOptions.isHidden = false
            
            // user will not be able to see keyboard
            textField.endEditing(true)
        }
    }
    
    func updateTargetScoreAndDailyPoints(id: String, targetPoints: String){
        print("This is the target points : \(targetPoints)")
        let activityRef = dbref.child("Activities/\(id)")
        print("This is activity ref....")
        print(activityRef)
        activityRef.updateChildValues(["targetPoints": targetPoints, "sprintDailyPoints": sprintDailyPoints])
    }
    
    @IBAction func moreInfoPressed(_ sender: UIButton) {
        self.createAlert(titleText: "Info", messageText: "Im about to drop some knowledge on you")
        print("more info was pressed")
    }
    
    func textFieldDidChange(_ textField: UITextField){
        textField.layer.borderColor = UIColor.clear.cgColor
    }
    
    func checkTextFields(textField: UITextField) -> Bool{
        if textField.text == ""{
            createAlert(titleText: "Error", messageText: "There is a textbox field that is empty")
            textField.layer.borderWidth = 2.0
            textField.layer.borderColor = UIColor.red.cgColor
            return false
        }else{
            if weekChoice != ""{
                print("There is a number selected for week choice")
                if let weekChoice = Int(weekChoice) ,let input = Int(textField.text!){
                    let maxDays = weekChoice * 7
                    if input > maxDays{
                        print("This is maxDays : \(maxDays)")
                        createAlert(titleText: "Error", messageText: "There is an input which has exceeded the max goal points according to the week choice. Choose a goal score equal to or less than \(maxDays)")
                        textField.layer.borderWidth = 2.0
                        textField.layer.borderColor = UIColor.red.cgColor
                        return false
                    }else if input <= 0{
                        createAlert(titleText: "Error", messageText: "There is an input which is below or equal to zero. Choose a goal score between 1 - \(maxDays)")
                        textField.layer.borderWidth = 2.0
                        textField.layer.borderColor = UIColor.red.cgColor
                        return false
                    }
                }
            }else{
                print("weekChoice is blank...")
                createAlert(titleText: "Error", messageText: "Please select how long the new sprint will last")
                weekTextField.layer.borderWidth = 2.0
                weekTextField.layer.borderColor = UIColor.red.cgColor
                return false
                
            }
        }
        return true
    }
    
    func checkFields() -> Bool{
        if !checkTextFields(textField: joyTargetScore1){
            return false
        }
        if !checkTextFields(textField: joyTargetScore2){
            return false
        }
        if !checkTextFields(textField: passionTargetScore1){
            return false
        }
        if !checkTextFields(textField: passionTargetScore2){
            return false
        }
        if !checkTextFields(textField: contributionTargetScore1){
            return false
        }
        if !checkTextFields(textField: contributionTargetScore2){
            return false
        }
        
        return true
    }
    
    @IBAction func submitPressed(_ sender: UIButton) {
        
        // add validation before updating to database, exit if their is empty fields
        let check = checkFields()
        if !check{
            return
        }
        
        print("GOING TO THE CATEGORY DB REFS...")
        let joySprintRef = dbref.child("Categories/\(categoryKey)/JoySprints/\(joySprintKey)")
        let passionSprintRef = dbref.child("Categories/\(categoryKey)/PassionSprints/\(passionSprintKey)")
        let contributionSprintRef = dbref.child("Categories/\(categoryKey)/ContributionSprints/\(contributionSprintKey)")
        
        setStartAndEndDate(weeks: weekChoice)
        print(sprintDailyPoints)
        
        // update starting date, ending date , number of weeks
        joySprintRef.updateChildValues(["startingDate": startingDate, "endingDate": endingDate, "numberOfWeeks": weekChoice])
        passionSprintRef.updateChildValues(["startingDate": startingDate, "endingDate": endingDate, "numberOfWeeks": weekChoice,])
        contributionSprintRef.updateChildValues(["startingDate": startingDate, "endingDate": endingDate, "numberOfWeeks": weekChoice])
        
        // update target score and sprint daily points
        print("Going to update joy activities")
        print("Joy activity 1 id : \(joyActivityIds[0])")
        print("Joy activity 2 id : \(joyActivityIds[1])")
        updateTargetScoreAndDailyPoints(id: joyActivityIds[0], targetPoints: joyTargetScore1.text!)
        updateTargetScoreAndDailyPoints(id: joyActivityIds[1], targetPoints: joyTargetScore2.text!)
        
        print("Going to update passion activities")
        print("Passion activity 1 id : \(passionActivityIds[0])")
        print("Passion activity 2 id : \(passionActivityIds[1])")
        updateTargetScoreAndDailyPoints(id: passionActivityIds[0], targetPoints: passionTargetScore1.text!)
        updateTargetScoreAndDailyPoints(id: passionActivityIds[1], targetPoints: passionTargetScore2.text!)
        
        print("Going to update contribution activities")
        print("Contribution activity 1 id : \(contributionActivityIds[0])")
        print("Contribution activity 2 id : \(contributionActivityIds[1])")
        updateTargetScoreAndDailyPoints(id: contributionActivityIds[0], targetPoints: contributionTargetScore1.text!)
        updateTargetScoreAndDailyPoints(id: contributionActivityIds[1], targetPoints: contributionTargetScore2.text!)
        
        segueCheck = true
        performSegue(withIdentifier: "newDashBoardSegue", sender: self)
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool{
        if segueCheck{
            return true
        }
        return false
    }
    
}










