//
//  PreviousCycleVC.swift
//  LifeManagementApp
//
//  Created by Eric Rado on 11/9/17.
//  Copyright © 2017 SeniorProject. All rights reserved.
//

import UIKit
import Firebase

class PreviousCycleVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var dbref = Database.database().reference(fromURL: "https://life-management-f0cdf.firebaseio.com/")
    var delegate = UIApplication.shared.delegate as! AppDelegate
    var userCategory = Category()
    
    // activities arrays
    var joyActivitiesDict = [String: Activity]()
    var passionActivitiesDict = [String: Activity]()
    var contributionActivitiesDict = [String: Activity]()
    
    // sprints will be passed to next screen when user selects table cell
    var joySprint = Sprint()
    var passionSprint = Sprint()
    var contributionSprint = Sprint()
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        getUserCategory()
    }
    
    func getUserCategory(){
        let categoryRef = dbref.child("Categories/\(self.delegate.categoryKey)")
        getSpecificCategory(ref: categoryRef.child("JoySprints"), option: "Joy")
        getSpecificCategory(ref: categoryRef.child("PassionSprints"), option: "Passion")
        getSpecificCategory(ref: categoryRef.child("ContributionSprints"), option: "Contribution")
        
    }
    
    func getSpecificCategory(ref: DatabaseReference, option: String){
        ref.queryOrdered(byChild: "startingDate").observe(.value, with: {(snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot]{
                if !child.exists(){
                    print("Snapshot is empty")
                    return
                }
                print(child)
                let newSprint = Sprint(snapshot: child)
                print(newSprint!)
                // add sprint to category specific array then get activities
                if option == "Joy"{
                    if let sprint = newSprint{
                        self.userCategory.joySprints.append(sprint)
                        self.getActivities(id1: sprint.sprintActivityId1, id2: sprint.sprintActivityId2, option: "Joy")
                    }
                    
                }else if option == "Passion"{
                    if let sprint = newSprint{
                        self.userCategory.passionSprints.append(sprint)
                        self.getActivities(id1: sprint.sprintActivityId1, id2: sprint.sprintActivityId2, option: "Passion")
                    }
                    
                }else{
                    if let sprint = newSprint{
                        self.userCategory.contributionSprints.append(sprint)
                        self.getActivities(id1: sprint.sprintActivityId1, id2: sprint.sprintActivityId2, option: "Contribution")
                    }
                }
            }
            
        }, withCancel: {(error) in
            print(error.localizedDescription)
        })
    }
    
    func getActivities(id1: String, id2: String, option: String){
        let activity1Ref = dbref.child("Activities/\(id1)")
        let activity2Ref = dbref.child("Activities/\(id2)")
        
        // get activity 1
        activity1Ref.observeSingleEvent(of: .value, with: {(snapshot) in
            print(snapshot)
            let activity = Activity(snapshot: snapshot)
            if option == "Joy"{
                if let newActivity = activity{
                    self.joyActivitiesDict[id1] = newActivity
                    print(self.joyActivitiesDict)
                }
            }else if option == "Passion"{
                if let newActivity = activity{
                    self.passionActivitiesDict[id1] = newActivity
                    print(self.passionActivitiesDict)
                }
            }else{
                if let newActivity = activity{
                    self.contributionActivitiesDict[id1] = newActivity
                    print(self.contributionActivitiesDict)
                }
            }
        }, withCancel: {(error) in
            print(error.localizedDescription)
        })
        
        // get activity 2
        activity2Ref.observeSingleEvent(of: .value, with: {(snapshot) in
            print(snapshot)
            let activity = Activity(snapshot: snapshot)
            if option == "Joy"{
                if let newActivity = activity{
                    self.joyActivitiesDict[id2] = newActivity
                    print(self.joyActivitiesDict)
                }
            }else if option == "Passion"{
                if let newActivity = activity{
                    self.passionActivitiesDict[id2] = newActivity
                    print(self.passionActivitiesDict)
                }
            }else{
                if let newActivity = activity{
                    self.contributionActivitiesDict[id2] = newActivity
                    print(self.contributionActivitiesDict)
                }
            }
            self.tableView.reloadData()

        }, withCancel: {(error) in
            print(error.localizedDescription)
        })
    }
    
    func getDate(startingDate: String, endingDate: String) -> String{
        let dateFmt = DateFormatter()
        dateFmt.dateFormat = "MMddyyyy"
        
        let startDate = dateFmt.date(from: startingDate)
        let endDate = dateFmt.date(from: endingDate)
        
        dateFmt.dateFormat = "MM/dd/yy"
        let startDateStr = dateFmt.string(from: startDate!)
        let endDateStr = dateFmt.string(from: endDate!)
        
        let str = "\(startDateStr) - \(endDateStr)"
        return str
    }
    
    func getScorePercentage(target1: String, actual1: String, target2: String, actual2: String) -> String{
        var avgScore: String
        var score: Double = ((Double(actual1)! / Double(target1)!) + (Double(actual2)! / Double(target2)!))/2
        score = score*100
        
        avgScore = String(format:"%.01f%"+"%", score)
        
        return avgScore
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userCategory.joySprints.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "summaryCell") as! PreviousCycleTableViewCell
        let newIndex = (self.userCategory.joySprints.count - 1) - indexPath.row
        
        var joySprint: Sprint?
        var passionSprint: Sprint?
        var contributionSprint: Sprint?
        
        // get user sprints
        joySprint = self.userCategory.joySprints[newIndex]
        if self.userCategory.passionSprints.indices.contains(newIndex){
            passionSprint = self.userCategory.passionSprints[newIndex]
        }
        if self.userCategory.contributionSprints.indices.contains(newIndex){
            contributionSprint = self.userCategory.contributionSprints[newIndex]
        }
        
        if let sprint = joySprint{
            cell.sprintDate.text = getDate(startingDate: sprint.startingDate, endingDate: sprint.endingDate)
        }
    
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            var act1: Activity
            var act2: Activity
            if let sprint = joySprint{
                if self.joyActivitiesDict.keys.contains(sprint.sprintActivityId1)
                    && self.joyActivitiesDict.keys.contains(sprint.sprintActivityId2){
                    act1 = self.joyActivitiesDict[sprint.sprintActivityId1]!
                    act2 = self.joyActivitiesDict[sprint.sprintActivityId2]!
                
                    cell.joyOverallScore.text = self.getScorePercentage(target1: act1.targetPoints,
                            actual1: act1.actualPoints,target2: act2.targetPoints, actual2: act2.actualPoints)
                }
            }
            if let sprint = passionSprint{
                if self.passionActivitiesDict.keys.contains(sprint.sprintActivityId1)
                    && self.passionActivitiesDict.keys.contains(sprint.sprintActivityId2){
                    act1 = self.passionActivitiesDict[sprint.sprintActivityId1]!
                    act2 = self.passionActivitiesDict[sprint.sprintActivityId2]!
                
                    cell.passionOverallScore.text = self.getScorePercentage(target1: act1.targetPoints,
                            actual1: act1.actualPoints,target2: act2.targetPoints, actual2: act2.actualPoints)
                }
            }
            if let sprint = contributionSprint{
                if self.contributionActivitiesDict.keys.contains(sprint.sprintActivityId1)
                    && self.contributionActivitiesDict.keys.contains(sprint.sprintActivityId2){
                    act1 = self.contributionActivitiesDict[sprint.sprintActivityId1]!
                    act2 = self.contributionActivitiesDict[sprint.sprintActivityId2]!
                
                    cell.contributionOverallScore.text = self.getScorePercentage(target1: act1.targetPoints,
                            actual1: act1.actualPoints, target2: act2.targetPoints, actual2: act2.actualPoints)
                }
            }
            
        })
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newIndex = (self.userCategory.joySprints.count - 1) - indexPath.row
        self.joySprint = self.userCategory.joySprints[newIndex]
        self.passionSprint = self.userCategory.passionSprints[newIndex]
        self.contributionSprint = self.userCategory.contributionSprints[newIndex]
        
        // This will perform the segue to PreviousCycleSummary
        performSegue(withIdentifier: "summaryCellSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "summaryCellSegue"){
            // initialize new view controller and cast it as your view controller
            let viewController = segue.destination as! PreviousCycleSummaryVC
            
            // new vc should have property that will store passed value
            viewController.joyActivity1 = self.joyActivitiesDict[self.joySprint.sprintActivityId1]!
            viewController.joyActivity2 = self.joyActivitiesDict[self.joySprint.sprintActivityId2]!
            viewController.passionActivity1 = self.passionActivitiesDict[self.passionSprint.sprintActivityId1]!
            viewController.passionActivity2 = self.passionActivitiesDict[self.passionSprint.sprintActivityId2]!
            viewController.contributionActivity1 = self.contributionActivitiesDict[self.passionSprint.sprintActivityId1]!
            viewController.contributionActivity2 = self.contributionActivitiesDict[self.contributionSprint.sprintActivityId2]!
        }
    }
    
    
}














