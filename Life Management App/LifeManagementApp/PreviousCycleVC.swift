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
    var joyActivitiesArr = [Activity]()
    var passionActivitiesArr = [Activity]()
    var contributionActivitiesArr = [Activity]()
    
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
                if option == "Joy"{
                    if let sprint = newSprint{
                        self.userCategory.joySprints.append(sprint)
                    }
                    
                }else if option == "Passion"{
                    if let sprint = newSprint{
                        self.userCategory.passionSprints.append(sprint)
                    }
                    
                }else{
                    if let sprint = newSprint{
                        self.userCategory.contributionSprints.append(sprint)
                    }
                }
            }
            
            self.tableView.reloadData()
            
            
        }, withCancel: {(error) in
            print(error.localizedDescription)
        })
    }
    
    func getActivities(id1: String, id2: String, option: String){
        let activity1Ref = dbref.child("Activities/\(id1)")
        let activity2Ref = dbref.child("Activities/\(id2)")
        
        print("Get activity 1 snapshot...")
        // get activity 1
        activity1Ref.observeSingleEvent(of: .value, with: {(snapshot) in
            print(snapshot)
            let activity = Activity(snapshot: snapshot)
            if option == "Joy"{
                if let newActivity = activity{
                    self.joyActivitiesArr.append(newActivity)
                    print(self.joyActivitiesArr)
                }
            }else if option == "Passion"{
                if let newActivity = activity{
                    self.passionActivitiesArr.append(newActivity)
                    print(self.passionActivitiesArr)
                }
            }else{
                if let newActivity = activity{
                    self.contributionActivitiesArr.append(newActivity)
                    print(self.contributionActivitiesArr)
                }
            }
        }, withCancel: {(error) in
            print(error.localizedDescription)
        })
        
        print("Get activity 2 snapshot...")
        // get activity 2
        activity2Ref.observeSingleEvent(of: .value, with: {(snapshot) in
            print(snapshot)
            let activity = Activity(snapshot: snapshot)
            if option == "Joy"{
                if let newActivity = activity{
                    self.joyActivitiesArr.append(newActivity)
                    print(self.joyActivitiesArr)
                }
            }else if option == "Passion"{
                if let newActivity = activity{
                    self.passionActivitiesArr.append(newActivity)
                    print(self.passionActivitiesArr)
                }
            }else{
                if let newActivity = activity{
                    self.contributionActivitiesArr.append(newActivity)
                    print(self.contributionActivitiesArr)
                }
            }

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
        print("This is target1 : \(target1)")
        print("This is actual1 : \(actual1)")
        print("This is target2 : \(target2)")
        print("This is actual2 : \(actual2)")
        
        var score: Double = ((Double(actual1)! / Double(target1)!) + (Double(actual2)! / Double(target2)!))/2
        score = score*100
        print("This is score : \(score)")
        
        avgScore = String(format:"%.01f%"+"%", score)
        
        return avgScore
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userCategory.joySprints.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "summaryCell") as! PreviousCycleTableViewCell
        print(self.userCategory.joySprints.count)
        let currentIndex = indexPath.row
        print("This is current index : \(currentIndex)")
        let newIndex = (self.userCategory.joySprints.count - 1) - currentIndex
        print("This is the newIndex : \(newIndex)")
        
        cell.sprintDate.text = getDate(startingDate: self.userCategory.joySprints[newIndex].startingDate, endingDate: self.userCategory.joySprints[newIndex].endingDate)
        
        // get activities from user category
        getActivities(id1: self.userCategory.joySprints[newIndex].sprintActivityId1, id2: self.userCategory.joySprints[newIndex].sprintActivityId2, option: "Joy")
        
        if(self.userCategory.passionSprints.indices.contains(newIndex)){
            getActivities(id1: self.userCategory.passionSprints[newIndex].sprintActivityId1, id2: self.userCategory.passionSprints[newIndex].sprintActivityId2, option: "Passion")
        }
        if(self.userCategory.contributionSprints.indices.contains(newIndex)){
            getActivities(id1: self.userCategory.contributionSprints[newIndex].sprintActivityId1, id2: self.userCategory.contributionSprints[newIndex].sprintActivityId2, option: "Contribution")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            cell.joyOverallScore.text = self.getScorePercentage(target1: self.joyActivitiesArr[newIndex*2].targetPoints, actual1: self.joyActivitiesArr[newIndex*2].actualPoints, target2: self.joyActivitiesArr[newIndex*2 + 1].targetPoints, actual2: self.joyActivitiesArr[newIndex*2 + 1].actualPoints)
            
            if(self.passionActivitiesArr.indices.contains(newIndex)){
                cell.passionOverallScore.text = self.getScorePercentage(target1: self.passionActivitiesArr[newIndex*2].targetPoints, actual1: self.passionActivitiesArr[newIndex*2].actualPoints, target2: self.passionActivitiesArr[newIndex*2 + 1].targetPoints, actual2: self.passionActivitiesArr[newIndex*2 + 1].actualPoints )
            }
            if(self.contributionActivitiesArr.indices.contains(newIndex)){
                cell.contributionOverallScore.text = self.contributionActivitiesArr[0].targetPoints
            }
        })
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
