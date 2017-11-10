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
                    self.userCategory.joySprints.append(newSprint!)
                }else if option == "Passion"{
                    self.userCategory.passionSprints.append(newSprint!)
                }else{
                    self.userCategory.contributionSprints.append(newSprint!)
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userCategory.joySprints.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "summaryCell") as! PreviousCycleTableViewCell
        let newIndex = (self.userCategory.joySprints.count - 1) - indexPath.row
        
        cell.sprintDate.text = getDate(startingDate: self.userCategory.joySprints[newIndex].startingDate, endingDate: self.userCategory.joySprints[newIndex].endingDate)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
