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
    let dbref = Database.database().reference(fromURL: "https://life-management-f0cdf.firebaseio.com/")
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
        
        weekOptions.isHidden = true
        
        loadImages()
        turnImageToCircle(picture: joyActivity1Img)
        turnImageToCircle(picture: joyActivity2Img)
        turnImageToCircle(picture: passionActivity1Img)
        turnImageToCircle(picture: passionActivity2Img)
        turnImageToCircle(picture: contributionActivity1Img)
        turnImageToCircle(picture: contributionActivity2Img)
        
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
    
    func setStartAndEndDate(weeks: String){
        let dateFmt = DateFormatter()
        dateFmt.dateFormat = "MMddyyyy"
        
        let currentDate = Date()
        
        var daysToAdd = 0
        
        // check the user week input to determine when is the sprint ending date
        if(weeks == "1"){
            daysToAdd = 7
        }else if(weeks == "2"){
            daysToAdd = 14
        }else{
            daysToAdd = 21
        }
        
        var dateComponent = DateComponents()
        
        dateComponent.day = daysToAdd
        
        let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
        
        startingDate = dateFmt.string(from: currentDate)
        endingDate = dateFmt.string(from: futureDate!)
        
        
    }
    
    func getSprintActivities(){
        // set references to the three different categories sprints location
        let joySprintsRef = dbref.child("Categories/\(categoryKey)/JoySprints")
        let passionSprintsRef = dbref.child("Categories/\(categoryKey)/PassionSprints")
        let contributionSprintsRef = dbref.child("Categories/\(categoryKey)/ContributionSprints")
        
        joySprintsRef.queryOrdered(byChild: "startingDate").queryEqual(toValue: "")
        passionSprintsRef.queryOrdered(byChild: "startingDate").queryEqual(toValue: "")
        contributionSprintsRef.queryOrdered(byChild: "startingDate").queryEqual(toValue: "")
        
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
                    print("This is passion activity id 1 : \(activityId2)")
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
                    print("This is contribution activity id 1 : \(activityId2)")
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
    
    func updateTargetScore(id: String, targetPoints: String){
        let activityRef = dbref.child("Activities/\(id)")
        activityRef.updateChildValues(["targetPoints": targetPoints])
    }
    
    
    
    @IBAction func moreInfoPressed(_ sender: Any) {
        print("More info pressed")
    }
    
    
    @IBAction func submitPressed(_ sender: Any) {
        
        updateTargetScore(id: joyActivityIds[0], targetPoints: joyTargetScore1.text!)
        updateTargetScore(id: joyActivityIds[1], targetPoints: joyTargetScore2.text!)
        
        updateTargetScore(id: passionActivityIds[0], targetPoints: passionTargetScore1.text!)
        updateTargetScore(id: passionActivityIds[1], targetPoints: passionTargetScore2.text!)
        
        updateTargetScore(id: contributionActivityIds[0], targetPoints: contributionTargetScore1.text!)
        updateTargetScore(id: contributionActivityIds[1], targetPoints: contributionTargetScore2.text!)
        
        let joySprintRef = dbref.child("Categories/\(categoryKey)/JoySprints/\(joySprintKey)")
        let passionSprintRef = dbref.child("Categories/\(categoryKey)/PassionSprints/\(passionSprintKey)")
        let contributionSprintRef = dbref.child("Categories/\(categoryKey)/ContributionSprints/\(contributionSprintKey)")
        
        print("WEEK CHOICE : \(weekChoice)")
        
        setStartAndEndDate(weeks: weekChoice)
        
        joySprintRef.updateChildValues(["startingDate": startingDate, "endingDate": endingDate, "numberOfWeeks": weekChoice])
        passionSprintRef.updateChildValues(["startingDate": startingDate, "endingDate": endingDate, "numberOfWeeks": weekChoice])
        contributionSprintRef.updateChildValues(["startingDate": startingDate, "endingDate": endingDate, "numberOfWeeks": weekChoice])
        
        performSegue(withIdentifier: "newDashBoardSegue", sender: self)
        
    }
    
}










