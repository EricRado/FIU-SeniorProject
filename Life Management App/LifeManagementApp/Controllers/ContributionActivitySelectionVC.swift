//
//  ContributionActivitySelectionVC.swift
//  LifeManagementApp
//
//  Created by Eric Rado on 10/23/17.
//  Copyright © 2017 SeniorProject. All rights reserved.
//

import UIKit
import Firebase

class ContributionActivitySelectionVC: UIViewController, iCarouselDataSource, iCarouselDelegate {
    var selectionIsValid = false
    var sprintCreatedId: String?
    var selectedIndexes = Set<Int>()
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    let dbref = Database.database().reference(fromURL: "https://life-management-v2.firebaseio.com/")
    
    @IBOutlet weak var submitBtn: UIButton! {
        didSet {
            submitBtn.layer.cornerRadius = 15
            submitBtn.layer.masksToBounds = true
        }
    }
    @IBOutlet var carouselView: iCarousel! {
        didSet {
            carouselView.delegate = self
            carouselView.dataSource = self
            carouselView.reloadData()
            carouselView.type = .coverFlow2
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return delegate.contributionImages.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
        // create a UIView
        let tempView = UIView(frame: CGRect(x: 0, y: 0, width: 225, height: 240))
        
        // get UIImageView from delegate array contributionImages
        let frame = CGRect(x: 0, y: 0, width: 225, height: 240)
        let uiImageView = delegate.contributionImages[index].uiImage
        uiImageView.frame = frame
        uiImageView.contentMode = .scaleToFill
        uiImageView.layer.cornerRadius = 10
        uiImageView.layer.masksToBounds = true
        
        // set the UIImageView to the tempView
        tempView.addSubview(uiImageView)
        
        return tempView
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == iCarouselOption.spacing {
            return value * 1.2
        }
        return value
    }
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        let uiImageView = delegate.contributionImages[index].uiImage
        
        // check if user activity selection reached max or if the activity is already selected
        if self.selectedIndexes.count < 2 && !self.selectedIndexes.contains(index){
            self.selectedIndexes.insert(index)
            uiImageView.layer.borderWidth = 1.5
            uiImageView.layer.borderColor = UIColor.green.cgColor
            return
        }
        
        // check if image was previously selected to clear the border if it was selected
        for selection in self.selectedIndexes{
            if selection == index{
                uiImageView.layer.borderColor = UIColor.clear.cgColor
                self.selectedIndexes.remove(index)
            }
        }
    }
    
    @IBAction func submitPressed(_ sender: Any) {
        // display alert if user did not select two activities
        if self.selectedIndexes.count != 2{
            self.createAlert(titleText: "Error", messageText: "Please select two activities before continuing")
            return
        }
        
        var activityIds = [String]()
        
        for selection in self.selectedIndexes{
            // generate new id for each activity selection and then store it
            let activityRef = dbref.child("Activities").childByAutoId()
            activityIds.append(activityRef.key)
            
            // store the image of the activity into array of selected activities for Sprint Setting Screen
            self.delegate.activitySelectedImages.append(self.delegate.contributionImages[selection].uiImage.image!)
            
            // get name of the activity selected
            let name = self.delegate.contributionImages[selection].name
            print("This is the name going to db : \(name)")
            
            // create a new Activity object to store in the database
            let newActivity = Activity(name: name, categoryId: self.delegate.categoryKey, userId: self.delegate.user.id)
            // Activity object is stored in the database
            activityRef.setValue(newActivity.toAnyObject(), withCompletionBlock: {(error,activityRef) in
                if error != nil{
                    print(error!)
                    return
                }
            })
        }
        
        // set a reference to PassionSprints and create a new record
        //let userCategoryRef = dbref.child("Categories/\(self.delegate.categoryKey)/ContributionSprints").childByAutoId()
        
        // TEST METHOD
        if let id = self.sprintCreatedId {
            let userCategoryRef = dbref
                .child("Categories/\(self.delegate.categoryKey)/ContributionSprints/\(id)")
            
            // create a new Sprint object to store in the database
            let newSprint = Sprint(categoryId: self.delegate.categoryKey, sprintActivityId1: activityIds[0], sprintActivityId2: activityIds[1])
            
            // Sprint object is stored in the database
            userCategoryRef.setValue(newSprint.toAnyObject(), withCompletionBlock: {(error, userCategoryRef) in
                if error != nil{
                    print(error!)
                    return
                }
            })
        } else {
            print("Id was not passed correctly")
            return
        }
        
        self.selectedIndexes.removeAll()
        
        // selection is valid set the flag to true, the segue will execute next
        self.selectionIsValid = true
        performSegue(withIdentifier: "SprintSettingSegue", sender: self)

    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if self.selectionIsValid{
            return true
        }
        return false
    }

}







