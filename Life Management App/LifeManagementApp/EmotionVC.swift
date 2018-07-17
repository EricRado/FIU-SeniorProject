//
//  EmotionVC.swift
//  LifeManagementApp
//
//  Created by Eric Rado on 7/15/18.
//  Copyright © 2018 SeniorProject. All rights reserved.
//

import UIKit
import Firebase

extension EmotionVC: UIViewControllerTransitioningDelegate{
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

class EmotionVC: UIViewController {
    // :- MARK Instance Variables
    
    var sprintOnDisplay: Sprint?
    var sprintViewModel: SprintViewModel?
    var activity1ViewModel: ActivityViewModel?
    var activity2ViewModel: ActivityViewModel?
    
    var activity1OnDisplay: Activity?
    var activity1OnDisplayId = ""
    var activity2OnDisplay: Activity?
    var activity2OnDisplayId = ""
    var sprintOnDisplayId = ""
    
    var btnIndexes = [Int]()
    
    var joyOverallScore = ""
    var passionOverallScore = ""
    var contributionOverallScore = ""
    
    var emotionChoice = ""
    
    let dbRef = Database.database()
        .reference(fromURL: "https://life-management-v2.firebaseio.com/")
    var imgUrlDbRef: DatabaseReference?
    
    var delegate = UIApplication.shared.delegate as! AppDelegate
    
    // :- MARK IBOutlet Instance Variables
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    
    @IBOutlet weak var a1GoalScoreLabel: UILabel! {
        didSet {
            turnLabelToCircle(a1GoalScoreLabel)
        }
    }
    @IBOutlet weak var a1ActualScoreLabel: UILabel! {
        didSet {
            turnLabelToCircle(a1ActualScoreLabel)
        }
    }
    @IBOutlet weak var a1ScorePercentageLabel: UILabel! {
        didSet {
            turnLabelToCircle(a1ScorePercentageLabel)
        }
    }
    
    @IBOutlet weak var a2GoalScoreLabel: UILabel! {
        didSet {
            turnLabelToCircle(a2GoalScoreLabel)
        }
    }
    @IBOutlet weak var a2ActualScoreLabel: UILabel! {
        didSet {
            turnLabelToCircle(a2ActualScoreLabel)
        }
    }
    @IBOutlet weak var a2ScorePercentageLabel: UILabel! {
        didSet {
            turnLabelToCircle(a2ScorePercentageLabel)
        }
    }
    
    
    @IBOutlet weak var a1Image: UIImageView! {
        didSet {
            turnImageToCircle(a1Image)
        }
    }
    @IBOutlet weak var a2Image: UIImageView! {
        didSet {
            turnImageToCircle(a2Image)
        }
    }
    
    @IBOutlet var daytopBtns: [UIButton]!
    @IBOutlet var dayBottomBtns: [UIButton]!
    
    @IBOutlet weak var emotionLabel: UILabel!
    
    @IBOutlet weak var emotionScorePercentageLabel: UILabel!
    @IBOutlet weak var overallScorePercentageLabel: UILabel!
    
    @IBOutlet weak var emotionScore: KDCircularProgress! {
        didSet {
            emotionScore.progressThickness = 0.5
        }
    }
    @IBOutlet weak var overallScore: KDCircularProgress!
    
    
    @IBOutlet weak var question1TextField: UITextField! {
        didSet {
            question1TextField.delegate = self
        }
    }
    @IBOutlet weak var question2TextField: UITextField! {
        didSet {
            question2TextField.delegate = self
        }
    }
    @IBOutlet weak var question3TextField: UITextField! {
        didSet {
            question3TextField.delegate = self
        }
    }
    @IBOutlet weak var question4TextField: UITextField! {
        didSet {
            question4TextField.delegate = self
        }
    }
    
    @IBOutlet weak var submitBtn: UIButton! {
        didSet {
            submitBtn.addTarget(self,
                                action: #selector(submitPressed(_:)),
                                for: .touchUpInside)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()

        // Do any additional setup after loading the view.
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "dropdown"), style: .plain, target: self, action: #selector(menuBtnPressed(_:)))
        self.navigationController?.navigationBar.barTintColor = .blue
        
        let pan = UIScreenEdgePanGestureRecognizer(target: self,
                                                   action: #selector(edgePanGestureTest(sender:)))
        pan.edges = .left
        pan.delegate = self
        self.view.addGestureRecognizer(pan)
        
    }
    
    func getCategoryKey(userId: String) {
        let categoryRef = dbRef.child("Categories")
        /* query the category collection and find the record which
         contains the current online user's id */
        let userCategoryQuery = categoryRef
            .queryOrdered(byChild: "userId")
            .queryEqual(toValue: userId)
        
        userCategoryQuery.observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                /* store the key of the user category collection in order to
                 make a reference to joy, contribution and passion sprints */
                print(child)
                self.delegate.categoryKey = child.key
                self.getActiveSprint(categoryKey: self.delegate.categoryKey,
                                     emotion: self.emotionChoice)
            }
        }, withCancel: {(error) in
            print(error.localizedDescription)
        })
    }
    
    func getActiveSprint(categoryKey: String, emotion: String) {
        print("This is emotion : \(emotion)")
        let emotionStr = "\(emotion)Sprints"
        let categoryRef = dbRef.child("Categories/\(categoryKey)/\(emotionStr)")
        
        let activeSprintQuery = categoryRef
            .queryOrdered(byChild: "startingDate")
            .queryLimited(toLast: 1)
        
        activeSprintQuery.observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                if !child.exists() {
                    print("Snapshot is empty")
                    return
                }
                print("snapshot key : \(child.key)")
                self.sprintOnDisplayId = child.key
                self.sprintOnDisplay = Sprint(snapshot: child)
                
                if let sprint = self.sprintOnDisplay {
                    self.activity1OnDisplayId = sprint.sprintActivityId1
                    self.activity2OnDisplayId = sprint.sprintActivityId2
                    self.getActivities(id1: self.activity1OnDisplayId,
                                       id2: self.activity2OnDisplayId)
                    self.sprintViewModel = SprintViewModel(sprint: sprint)
                    self.setDatesAndGoalsText()
                } else {
                    print("Data was not downloaded properly")
                    return
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getActivities(id1: String, id2: String) {
        
        // set two reference db points to each activity that will be displayed on dashboard
        let activity1Ref = dbRef.child("Activities/\(id1)")
        let activity2Ref = dbRef.child("Activities/\(id2)")
        
        activity1Ref.observe(.value, with: { (snapshot) in
            if !snapshot.exists() {
                print("Snapshot is empty...")
                return
            }
            print(snapshot)
    
            self.activity1OnDisplay = Activity(snapshot: snapshot)
            if let activity = self.activity1OnDisplay {
                self.activity1ViewModel = ActivityViewModel(activity: activity,
                                                            sprint: self.sprintOnDisplay!)
                self.setScoresAndPercentages(activityViewModel: self.activity1ViewModel!, option: "1")
                self.setAverageEmotionScore()
                self.setCalendar(btnArray: self.daytopBtns,
                                 dailyPointsStr: activity.sprintDailyPoints,
                                 position: Position.Top)
                self.a1Image.downloadActivityImg(url: self.imgUrlDbRef?.child("\(self.activity1ViewModel!.activityName)/"))
            } else {
                print("Error parsing activity 1 data")
                return
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        activity2Ref.observe(.value, with: { (snapshot) in
            if !snapshot.exists() {
                print("Snapshot is empty...")
                return
            }
            print(snapshot)
            self.activity2OnDisplay = Activity(snapshot: snapshot)
            if let activity = self.activity2OnDisplay {
                self.activity2ViewModel = ActivityViewModel(activity: activity,
                                                            sprint: self.sprintOnDisplay!)
                self.setScoresAndPercentages(activityViewModel: self.activity2ViewModel!, option: "2")
                self.setAverageEmotionScore()
                self.setCalendar(btnArray: self.dayBottomBtns,
                                 dailyPointsStr: activity.sprintDailyPoints,
                                 position: Position.Bottom)
                self.a2Image.downloadActivityImg(url: self.imgUrlDbRef?.child(
                    "\(self.activity2ViewModel!.activityName)/"))
            } else {
                print("Error parsing activity 2 data")
                return
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func setDatesAndGoalsText() {
        self.startDateLabel.text = sprintViewModel?.startingDateFormatted
        self.endDateLabel.text = sprintViewModel?.endingDateFormatted
        
        self.question1TextField.text = sprintViewModel?.goal1
        self.question2TextField.text = sprintViewModel?.goal2
        self.question3TextField.text = sprintViewModel?.goal3
        self.question4TextField.text = sprintViewModel?.goal4
    }
    
    func setScoresAndPercentages(activityViewModel: ActivityViewModel, option: String) {
        if option == "1" {
            self.a1ActualScoreLabel.text = activityViewModel.actualPoints
            self.a1GoalScoreLabel.text = activityViewModel.targetPoints
            self.a1ScorePercentageLabel.text = activityViewModel.goalPercentageStr
        } else {
            self.a2ActualScoreLabel.text = activityViewModel.actualPoints
            self.a2GoalScoreLabel.text = activityViewModel.targetPoints
            self.a2ScorePercentageLabel.text = activityViewModel.goalPercentageStr
        }
    }
    
    // set the average percentage score label and KDCircular progress bar for the emotion
    func setAverageEmotionScore() {
        if let goalPercentage1 = self.activity1ViewModel?.goalPercentage,
            let goalPercentage2 = self.activity2ViewModel?.goalPercentage {
            let emotionAverage = (goalPercentage1 + goalPercentage2) / 2.0
            
            // format the average double such as 50.1%
            self.emotionScorePercentageLabel.text = String(format: "%.01f%" + "%", emotionAverage)
            
        }
    }
    
    func setCalendar(btnArray: [UIButton], dailyPointsStr: String, position: Position) {
        let dateFmt = DateFormatter()
        
        // convert date strings to date objects
        dateFmt.dateFormat = "MMddyyyy"
        let startDate = dateFmt.date(from: self.sprintOnDisplay!.startingDate)
        
        // save start month will be used to check if the date has changed to a new month
        let startMonth = Calendar.current.component(.month, from: startDate!)
        
        // determine the day of the week such as Wednesday = 3 or Friday = 5
        // the day of the week is substracted by 1 because the button tags start at index 0
        let dayOfTheWeek = Int(Calendar.current.component(.weekday, from: startDate!)) - 1
        
        // extract the day the sprint starts from the starting date
        var startDay = Calendar.current.component(.day, from: startDate!)
        
        // determine the last day of the sprint from the number of weeks input by the user
        let dayCountInWeekChoice = (Int(self.sprintOnDisplay!.numberOfWeeks)! * 7) - 1
        var dayCounter = 0
        
        // store the indices of all the day buttons that are displayed on the calendar
        var dateComponent = DateComponents()
        
        // month flag is used to make sure the reset of startDay is only executed once
        var monthFlag = true
        
        // setup the calendar display
        for button in btnArray {
            // get the date about to be displayed and extract the month from the date
            dateComponent.day = dayCounter
            let date = Calendar.current.date(byAdding: dateComponent, to: startDate!)
            let checkMonth = Calendar.current.component(.month, from: date!)
            
            if checkMonth != startMonth && monthFlag {
                startDay = 1
                monthFlag = false
            }
            
            if button.tag < dayOfTheWeek {
                hideButton(button)
            }
            if (dayOfTheWeek <= button.tag) && (dayCounter <= dayCountInWeekChoice) {
                // store the indices of all the day buttons that are displayed on the calendar
                self.btnIndexes.append(button.tag)
                
                // store position property for button that is going to be displayed
                if position == Position.Top {
                    button.position = .Top
                } else if position == Position.Bottom {
                    button.position = .Bottom
                }
                
                // add button action
                button.addTarget(self,
                                 action: #selector(dayBtnPressed(_:)),
                                 for: .touchUpInside)
                
                startDay += 1
                dayCounter += 1
            } else {
                hideButton(button)
            }
            
        }
        
        var counter = 0
        
        // setup the sprint daily points
        for index in dailyPointsStr.indices {
            if dailyPointsStr[index] == "1" {
                // get the index of the button on display
                let btnIndex = self.btnIndexes[counter]
                btnArray[btnIndex].backgroundColor = UIColor.green
            }
            counter += 1
        }
    }
    
    func setActivityImg(activityName: String, option: String) {
        
    }
    
    @objc func dayBtnPressed(_ sender: UIButton) {
        let activity: ActivityViewModel?
        let activityId: String?
        let newScore: Int
        
        switch sender.position {
        case .Top:
            print("Top button was pressed")
            activity = activity1ViewModel
            activityId = self.sprintViewModel?.activityId1
        case .Bottom:
            print("Bottom button was pressed")
            activity = activity2ViewModel
            activityId = self.sprintViewModel?.activityId2
        case .NotApplicable:
            return
        }
        
        // store the index that will be changed in sprint daily points
        let index = Int(self.btnIndexes.index(of: sender.tag)!)
        
        if sender.backgroundColor == UIColor.green {
            // the score has decreased
            newScore = Int((activity!.actualPoints))! - 1
            sender.backgroundColor = UIColor.gray
        } else {
            // the score has increased
            newScore = Int(activity!.actualPoints)! + 1
            sender.backgroundColor = UIColor.green
        }
        activity?.actualPoints = String(newScore)
        activity?.updateActualScoreAndDailyPoints(activityId: activityId!,
                                                  dailyPointsModifiedIndex: index)
        
    }
    
    @objc func submitPressed(_ sender: UIButton) {
        // retrieve goals text from text fields
        // if field is blank set to empty string
        self.sprintViewModel?.goal1 = self.question1TextField.text ?? ""
        self.sprintViewModel?.goal2 = self.question2TextField.text ?? ""
        self.sprintViewModel?.goal3 = self.question3TextField.text ?? ""
        self.sprintViewModel?.goal4 = self.question4TextField.text ?? ""
        
        // update the new goals to the database
        self.sprintViewModel?.updateGoals(emotion: self.emotionChoice,
                                          sprintId: self.sprintOnDisplayId,
                                          viewController: self)
    }

}
protocol Gesture {
    var interactor: Interactor {
        get
    }
}

extension EmotionVC: Gesture, UIGestureRecognizerDelegate {
    var interactor: Interactor {
        get {
            return Interactor()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? SideMenuViewController{
            destinationViewController.transitioningDelegate = self
            // pass the interactor object forward
            destinationViewController.interactor = interactor
        }
    }
    
    @objc func edgePanGestureTest(sender: UIScreenEdgePanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        let progress = MenuHelper.calculateProgress(translationInView: translation,
                                                    viewBounds: view.bounds,
                                                    direction: .Right)
        
        MenuHelper.mapGestureStateToInteractor(gestureState: sender.state, progress: progress, interactor: interactor) {
            self.performSegue(withIdentifier: "openMenu", sender: nil)
        }
    }
}

extension UIViewController: UITextFieldDelegate {
    
    
    func turnLabelToCircle(_ label: UILabel) {
        label.layer.cornerRadius = label.frame.size.width / 2
        label.clipsToBounds = true
    }
    
    func turnImageToCircle(_ image: UIImageView) {
        image.layer.cornerRadius = image.frame.size.width / 2
        image.clipsToBounds = true
       
    }
    
    func hideButton(_ button: UIButton) {
        button.alpha = 0.0
        button.isUserInteractionEnabled = false
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func menuBtnPressed(_ sender: UIBarButtonItem) {
        print("dropdown button pressed")
        performSegue(withIdentifier: "openMenu", sender: nil)
    }
    
}







