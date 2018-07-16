//
//  EmotionVC.swift
//  LifeManagementApp
//
//  Created by Eric Rado on 7/15/18.
//  Copyright © 2018 SeniorProject. All rights reserved.
//

import UIKit
import Firebase

class EmotionVC: UIViewController {
    // :- MARK Instance Variables
    var sprintOnDisplay: Sprint?
    var sprintViewModel: SprintViewModel?
    var activityViewModel: ActivityViewModel?
    
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
        self.emotionScore.progressThickness = 0.5
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "dropdown"), style: .plain, target: self, action: #selector(menuBtnPressed(_:)))
        self.submitBtn.addTarget(self,
                                 action: #selector(submitPressed(_:)),
                                 for: .touchUpInside)
        self.navigationController?.navigationBar.barTintColor = .blue
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
            if let activity1 = self.activity1OnDisplay {
                print("Activity was set")
                print(activity1)
            } else {
                print("Activity was not set")
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
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func setDatesAndGoalsText() {
        self.startDateLabel.text = sprintViewModel?.startingDateFormatted
        self.endDateLabel.text = sprintViewModel?.endingDateFormatted
        
        
    }
    
    func setScoresAndPercentages() {
        
    }
    
    @objc func submitPressed(_ sender: UIButton) {
        print("submit was pressed")
    }

}

extension UIViewController {
    func turnLabelToCircle(_ label: UILabel) {
        label.layer.cornerRadius = label.frame.size.width / 2
        label.clipsToBounds = true
    }
    
    func turnImageToCircle(_ image: UIImageView) {
        image.layer.cornerRadius = image.frame.size.width / 2
        image.clipsToBounds = true
        self.view.layoutIfNeeded()
    }
    
    @objc func menuBtnPressed(_ sender: UIBarButtonItem) {
        print("dropdown button pressed")
    }
}






