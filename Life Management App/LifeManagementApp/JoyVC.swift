//
//  JoyVC.swift
//  LifeManagementApp
//
//  Created by Eric Rado on 9/26/17.
//  Copyright © 2017 SeniorProject. All rights reserved.
//

import UIKit
import Firebase

extension String {
    
    //Enables replacement of the character at a specified position within a string
    func replace(_ index: Int, _ newChar: Character) -> String {
        var chars = Array(characters)
        chars[index] = newChar
        let modifiedString = String(chars)
        return modifiedString
    }
}

extension JoyVC: UIViewControllerTransitioningDelegate{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentMenuAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissMenuAnimator()
    }
    
    /* indicate that the dismiss transition is going to be interactive, but
       only if the user is panning */
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}

class JoyVC: UIViewController {
    
    let interactor = Interactor()
    
    var sprintOnDisplay: Sprint = Sprint()
    var activity1OnDisplay: Activity = Activity()
    var activity2OnDisplay: Activity = Activity()
    var btnIndexes = [Int]()
    
    @IBOutlet weak var goalScore1: UILabel!
    @IBOutlet weak var goalScore2: UILabel!
    @IBOutlet weak var currentScore1: UILabel!
    @IBOutlet weak var currentScore2: UILabel!
    @IBOutlet weak var joyActivity1Img: UIImageView!
    @IBOutlet weak var joyActivity2Img: UIImageView!
    
    @IBOutlet weak var goalPercentage1: UILabel!
    @IBOutlet weak var goalPercentage2: UILabel!
    
    @IBOutlet weak var startingDate: UILabel!
    @IBOutlet weak var endingDate: UILabel!
    
    // goal text fields
    @IBOutlet weak var goal1TextField: UITextField!
    @IBOutlet weak var goal2TextField: UITextField!
    @IBOutlet weak var goal3TextField: UITextField!
    @IBOutlet weak var goal4TextField: UITextField!
    
    @IBOutlet var dayBtns: [UIButton]!
    
    @IBOutlet var dayBottomBtns: [UIButton]!
    
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    
    @IBOutlet weak var joyScore: KDCircularProgress!
    @IBOutlet weak var joyScoreLabel: UILabel!
    
    var dbref = Database.database().reference(fromURL: "https://life-management-f0cdf.firebaseio.com/")
    var delegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layoutIfNeeded()
        
        self.joyScore.progressThickness = 0.5
        
        // turn label and images to circles
        
        turnLabelToCircle(label: goalScore1)
        turnLabelToCircle(label: goalScore2)
        
        turnLabelToCircle(label: goalPercentage1)
        turnLabelToCircle(label: goalPercentage2)
        
        turnLabelToCircle(label: currentScore1)
        turnLabelToCircle(label: currentScore2)
        
        getCategoryKey(userId: self.delegate.user.id)
    
    }
    
    func turnLabelToCircle(label: UILabel){
        label.layer.cornerRadius = label.frame.size.width / 2
        label.clipsToBounds = true
    }
    
    
    func turnImageToCircle(picture: UIImageView){
        picture.layer.cornerRadius = picture.frame.size.width / 2
        picture.clipsToBounds = true
        self.view.layoutIfNeeded()
    }

    func getCategoryKey(userId: String){
        let categoryRef = dbref.child("Categories")
        /* query the category collection and find the record which
         contains the current online user's id */
        let userCategoryQuery = categoryRef.queryOrdered(byChild: "userId").queryEqual(toValue: userId)
        
        userCategoryQuery.observeSingleEvent(of: .value, with: {(snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot]{
                /* store the key of the user category collection in order to
                 make a reference to joy, contribution and passion sprints */
                self.delegate.categoryKey = child.key
                self.getActiveSprint(categoryKey: self.delegate.categoryKey)
            }
        }, withCancel: {(error) in
            print(error.localizedDescription)
        })
    }
    
    func getActiveSprint(categoryKey: String){
        let categoryRef = dbref.child("Categories/\(categoryKey)/JoySprints")
        
        // get the latest sprint
        let activeSprintQuery = categoryRef.queryOrdered(byChild: "startingDate").queryLimited(toLast: 1)
        
        activeSprintQuery.observeSingleEvent(of: .value, with: {(snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot]{
                if !child.exists(){
                    print("Snapshot is empty")
                    return
                }
                
                self.sprintOnDisplay = Sprint(snapshot: child)!
                
                let activityId1 = self.sprintOnDisplay.sprintActivityId1
                let activityId2 = self.sprintOnDisplay.sprintActivityId2
                self.getActivities(id1: activityId1, id2: activityId2)

                self.setDates()
                self.setGoalsText()
                
            }
        }, withCancel: {
            (error) in print(error.localizedDescription)
        })
    }
    
    func getActivities(id1: String, id2: String){
      
        //set two referencece points to each activity that will be displayed on dashboard
        let activity1Ref = Database.database().reference(withPath: "Activities/\(id1)")
        let activity2Ref = Database.database().reference(withPath: "Activities/\(id2)")
        
        // get activity 1 values from the database
        activity1Ref.observe(.value, with: {(snapshot) in
            if !snapshot.exists(){
                print("Snapshot is empty...")
                return
            }
            
            let activityDict = snapshot.value as? [String:Any]
            self.activity1OnDisplay = self.parseActivityDictionary(dict: activityDict!)
            
            self.setScoresAndPercentages()
            self.setActivityImg(activityName: self.activity1OnDisplay.name, option: "1")
            self.setCalendar(btnArray: self.dayBtns, dailyPointsStr: self.activity1OnDisplay.sprintDailyPoints)
        })
        
        // get activity 2 values from the database
        activity2Ref.observe(.value, with: {(snapshot) in
            if !snapshot.exists(){
                print("Snapshot is empty...")
                return
            }
            let activityDict = snapshot.value as? [String:Any]
            self.activity2OnDisplay = self.parseActivityDictionary(dict: activityDict!)
            
            self.setScoresAndPercentages()
            self.setActivityImg(activityName: self.activity2OnDisplay.name, option: "2")
            self.setCalendar(btnArray: self.dayBottomBtns, dailyPointsStr: self.activity2OnDisplay.sprintDailyPoints)
        })
        
    }
    
    func parseActivityDictionary(dict: [String:Any]) -> Activity{
        let name = dict["name"] as? String
        let activityScore = dict["activityScore"] as? String
        let targetPoints = dict["targetPoints"] as? String
        let actualPoints = dict["actualPoints"] as? String
        let categoryId = dict["categoryId"] as? String
        let userId = dict["userId"] as? String
        let sprintDailyPoints = dict["sprintDailyPoints"] as? String
        
        let activity = Activity(name:name!, activityScore: activityScore!,  actualPoints:actualPoints!,targetPoints: targetPoints!,sprintDailyPoints: sprintDailyPoints!, categoryId: categoryId!,userId: userId!)
        
        return activity
    }
    
    func setScoresAndPercentages(){
        self.goalScore1?.text = self.activity1OnDisplay.targetPoints
        self.goalScore2?.text = self.activity2OnDisplay.targetPoints
        
        self.currentScore1?.text = self.activity1OnDisplay.actualPoints
        self.currentScore2?.text = self.activity2OnDisplay.actualPoints
        
        var goalP1:Double?
        var goalP2:Double?
        
        // set goal percentage actual/target for activity 1
        // use if let to safely unwrap values in case any are nils
        if let actual1 = Double(self.activity1OnDisplay.actualPoints), let target1 =
            Double(self.activity1OnDisplay.targetPoints){
            goalP1 = (actual1 / target1) * 100
            let goalP1Int = Int(round(goalP1!))
            if goalP1Int >= 100{
                self.goalPercentage1?.text = "100%"
            }else{
                self.goalPercentage1?.text = "\(String(goalP1Int))%"
            }
        }else{return}
        
        // set goal percentage actual/target for activity 2
        if let actual2 = Double(self.activity2OnDisplay.actualPoints), let target2 =
            Double(self.activity2OnDisplay.targetPoints){
            goalP2 = (actual2 / target2) * 100
            let goalP2Int = Int(round(goalP2!))
            if goalP2Int >= 100{
                self.goalPercentage2?.text = "100%"
            }else{
                self.goalPercentage2?.text = "\(String(goalP2Int))%"
            }
        }else{return}
        
        // find the average score of both joy activies by taking their 
        // percentage score for each activity and dividing by 2
        if let p1 = goalP1, let p2 = goalP2{
            let joyAvg = ((p1 + p2)/2.0)
            let joyAvgInt = Int(round(joyAvg * 3.6))
            self.joyScore.angle = Double(joyAvgInt)
            self.joyScoreLabel?.text = String(format:"%.01f%"+"%", joyAvg)
            
        }else{return}

    }
    
    func setDates(){
        
        let dateFmt = DateFormatter()
        
        // convert date strings to date objects
        dateFmt.dateFormat = "MMddyyyy"
        let startDate = dateFmt.date(from: self.sprintOnDisplay.startingDate)
        let endDate = dateFmt.date(from: self.sprintOnDisplay.endingDate)
        
        // format dates to MM/dd/yyyy
        dateFmt.dateFormat = "MM/dd/yyyy"
        let startDateStr = dateFmt.string(from: startDate!)
        let endDateStr = dateFmt.string(from: endDate!)
        
        // assign new date strings to their respective labels
        startingDate?.text = startDateStr
        endingDate?.text = endDateStr
    }
    
    func setCalendar(btnArray: [UIButton],dailyPointsStr: String){
        let dateFmt = DateFormatter()
        
        // convert date strings to date objects
        dateFmt.dateFormat = "MMddyyyy"
        let startDate = dateFmt.date(from: self.sprintOnDisplay.startingDate)
        
        // save start month will be used to check if the date has changed to a new month
        let startMonth = Calendar.current.component(.month, from: startDate!)
        
        // determine the day of the week such as Wenesday = 3 or Friday = 5
        // the day of the week is substracted by 1 because the button tags start at index 0
        let dayOfTheWeek = Int(Calendar.current.component(.weekday, from: startDate!)) - 1
        
        // extract the day the sprint starts from starting date
        var startDay = Calendar.current.component(.day, from: startDate!)
        
        // determine the last day of the sprint from the number of weeks input by the user
        let dayCountInWeekChoice = (Int(self.sprintOnDisplay.numberOfWeeks)! * 7) - 1
        var dayCounter = 0
        
        // store the indexes of all the day buttons that are displayed on the calendar
        
        
        var dateComponent = DateComponents()
        
        // month flag is used to make sure the reset of startDay is only executed once
        var monthFlag = true
        
        // setup the calendar display
        for button in btnArray{
            // get the date about to be displayed and extract the month from the date
            dateComponent.day = dayCounter
            let date = Calendar.current.date(byAdding: dateComponent, to: startDate!)
            let checkMonth = Calendar.current.component(.month, from: date!)
            
            /* with the month extracted compare it to the start day month, if they are not
             equal a new month has begun. Reset startDay to 1, to display a valid day*/
            if checkMonth != startMonth && monthFlag{
                startDay = 1
                monthFlag = false
            }
            
            if button.tag < dayOfTheWeek{
                button.isHidden = true
            }
            if (dayOfTheWeek <= button.tag) &&  (dayCounter <= dayCountInWeekChoice){
                button.setTitle(String(startDay), for: .normal)
                
                // store the indexes of all the day buttons that are displayed on the calendar
                self.btnIndexes.append(button.tag)
                startDay = startDay + 1
                dayCounter = dayCounter + 1
            }else{
                button.isHidden = true
            }
        }
        
        var counter = 0
        
        // setup the sprint daily points
        for index in dailyPointsStr.characters.indices{
            if dailyPointsStr[index] == "1"{
                // get the index of the button on display
                let btnIndex = self.btnIndexes[counter]
                btnArray[btnIndex].backgroundColor = UIColor.green
            }
            counter = counter + 1
        }
    }
    
    func setGoalsText(){
        self.goal1TextField.text = self.sprintOnDisplay.goal1
        self.goal2TextField.text = self.sprintOnDisplay.goal2
        self.goal3TextField.text = self.sprintOnDisplay.goal3
        self.goal4TextField.text = self.sprintOnDisplay.goal4
    }
    
    func setActivityImg(activityName: String, option: String){
        let imgUrlDBref = Database.database().reference(withPath: "ActivityImgs/JoyActivities/")
        let imgUrlQuery = imgUrlDBref.queryOrdered(byChild: "name")
            .queryEqual(toValue: activityName)
        
        // get url for the activity image from DataSnapshot
        imgUrlQuery.observeSingleEvent(of: .value, with: {(snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot]{
                var dict = child.value as? [String: Any]
                if let url = dict?["url"] as? String{
                    let imgRef = storage.reference(forURL: url)
                    imgRef.getData(maxSize: 1 * 1024 * 1024, completion: {data,error in
                        if let error = error {
                            print(error.localizedDescription)
                            return
                        }else{
                            if option == "1"{
                                self.joyActivity1Img.image = UIImage(data:data!)
                                self.turnImageToCircle(picture: self.joyActivity1Img)
                            }else{
                                self.joyActivity2Img.image = UIImage(data:data!)
                                self.turnImageToCircle(picture: self.joyActivity2Img)
                            }
                            
                        }
                    })
                }
            }
        })
    }
    
    func updateActualScoreAndDailyPoints(newScore: String, id: String, dailyPointsIndex: Int, dailyPoints: String){
        // update daily points
        let index = dailyPoints.index(dailyPoints.startIndex, offsetBy: dailyPointsIndex)
        let value = dailyPoints[index]
        var newDailyPoints: String
        
        // modify the daily points string according the value found
        if value == "1"{
            newDailyPoints = dailyPoints.replace(dailyPointsIndex, "0")
        }else{
            newDailyPoints = dailyPoints.replace(dailyPointsIndex, "1")
        }
        
        // update the new sprint daily points to the database
        let activityRef = dbref.child("Activities/\(id)")
        activityRef.updateChildValues(["actualPoints": newScore,"sprintDailyPoints": newDailyPoints])
    }
    
    func updateGoals(goal1: String, goal2: String, goal3: String, goal4: String){
        // query by starting date to find the key of the current sprint displayed
        let categoryRef = dbref.child("Categories/\(self.delegate.categoryKey)/JoySprints/")
        let query = categoryRef.queryOrdered(byChild: "startingDate").queryEqual(toValue: self.sprintOnDisplay.startingDate)
        
        query.observeSingleEvent(of: .value, with: {(snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot]{
                // store the key of the sprint which the goals will be updated to
                let updateKey = child.key
                
                // create a reference to the location with the key and the update the new values
                let updateRef = self.dbref.child("Categories/\(self.delegate.categoryKey)/JoySprints/\(updateKey)/")
                updateRef.updateChildValues(["goal1": goal1, "goal2": goal2, "goal3": goal3, "goal4": goal4])
            }
        }, withCancel: {
            (error) in print(error.localizedDescription)
        })
    }
    
    @IBAction func topDayBtnPressed(_ sender: UIButton) {
        var newScore: Int
        
        // store the index that will be changed in sprint daily points
        let index = self.btnIndexes.index(of: sender.tag)
        let indexInt = Int(index!)

        if sender.backgroundColor == UIColor.green{
            // the score has decreased
            newScore = Int(self.activity1OnDisplay.actualPoints)! - 1
            sender.backgroundColor = UIColor.lightGray
        }else{
            // the score has increased
            newScore = Int(self.activity1OnDisplay.actualPoints)! + 1
            sender.backgroundColor = UIColor.green
        }
      
        updateActualScoreAndDailyPoints(newScore: String(newScore), id: self.sprintOnDisplay.sprintActivityId1,
                        dailyPointsIndex: indexInt, dailyPoints: self.activity1OnDisplay.sprintDailyPoints)
    }
    
    @IBAction func bottomDayBtnPressed(_ sender: UIButton) {
        var newScore: Int
        
        // store the index that will be changed in sprint daily points
        let index = self.btnIndexes.index(of: sender.tag)
        let indexInt = Int(index!)
        
        if sender.backgroundColor == UIColor.green{
            // the score has decreased
            newScore = Int(self.activity2OnDisplay.actualPoints)! - 1
            sender.backgroundColor = UIColor.lightGray
        }else{
            // the score has increased
            newScore = Int(self.activity2OnDisplay.actualPoints)! + 1
            sender.backgroundColor = UIColor.green
        }
        updateActualScoreAndDailyPoints(newScore: String(newScore), id: self.sprintOnDisplay
            .sprintActivityId2, dailyPointsIndex: indexInt, dailyPoints: self.activity2OnDisplay.sprintDailyPoints)
    }
    
    
    @IBAction func submitPressed(_ sender: UIButton) {
        // update the new goals to the database
        updateGoals(goal1: goal1TextField.text!, goal2: goal2TextField.text!, goal3: goal3TextField.text!, goal4: goal4TextField.text!)
    }


    /***********************************************************
 
                        Side Menu Functions
 
    ***********************************************************/
    
    
    @IBAction func openMenu(_ sender: AnyObject){
        performSegue(withIdentifier: "openMenu", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? SideMenuViewController{
            destinationViewController.transitioningDelegate = self
            // pass the interactor object forward
            destinationViewController.interactor = interactor
        }
    }
    
    @IBAction func edgePanGesture(sender: UIScreenEdgePanGestureRecognizer){
        let translation = sender.translation(in: view)
        
        let progress = MenuHelper.calculateProgress(translationInView: translation, viewBounds: view.bounds, direction: .Right)
        
        MenuHelper.mapGestureStateToInteractor(gestureState: sender.state, progress: progress, interactor: interactor){
                self.performSegue(withIdentifier: "openMenu", sender: nil)
        }
    }
    

}
