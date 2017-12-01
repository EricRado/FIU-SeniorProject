//
//  JoyActivitySelectionVC.swift
//  LifeManagementApp
//
//  Created by Eric Rado on 10/11/17.
//  Copyright © 2017 SeniorProject. All rights reserved.
//

import UIKit
import Firebase


class JoyActivitySelectionVC: UIViewController, iCarouselDataSource, iCarouselDelegate {
    var selectionIsValid = false

    @IBOutlet var joyCarouselView: iCarousel!
    @IBOutlet weak var displayUsername: UILabel!
    @IBOutlet weak var submitBtn: UIButton!
    
    var selectedIndexes = Set<Int>()
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    let dbRef = Database.database().reference(fromURL: "https://life-management-v2.firebaseio.com/")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        joyCarouselView.delegate = self
        joyCarouselView.dataSource = self
        joyCarouselView.reloadData()
        joyCarouselView.type = .coverFlow2
        
        submitBtn.layer.cornerRadius = 15
        submitBtn.layer.masksToBounds = true
        
        self.createCategory()
    }
    
    func numberOfItems(in carousel: iCarousel) ->Int {
        return delegate.joyImages.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView{
        
        // create a UIView
        let tempView = UIView(frame: CGRect(x: 0, y: 0, width: 225, height: 240))
        
        // get UIImageView from delegate array joyImages
        let frame = CGRect(x: 0, y: 0, width: 225, height: 240)
        let uiImageView = delegate.joyImages[index].uiImage
        uiImageView.frame = frame
        uiImageView.contentMode = .scaleToFill
        uiImageView.layer.cornerRadius = 10
        uiImageView.layer.masksToBounds = true
        uiImageView.clipsToBounds = true
        
        
        // set the UIImageView to the tempView
        tempView.addSubview(uiImageView)  
        
        return tempView
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat)  -> CGFloat {
        if option == iCarouselOption.spacing {
            return value * 1.2
        }
        return value
    }
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        let uiImageView = delegate.joyImages[index].uiImage
        
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
    
    func createCategory(){
        // if a category key already exists do not create a new category, its not a first time user
        if self.delegate.categoryKey != ""{
            print("This is the category key : \(self.delegate.categoryKey)")
            return
        }
        let categoryRef = dbRef.child("Categories").childByAutoId()
        self.delegate.categoryKey = categoryRef.key
        print("Category Key : \(self.delegate.categoryKey)")
        
        // create a new Category collection in the database for the new user
        categoryRef.setValue(["userId": self.delegate.user.id], withCompletionBlock: {(error,categoryRef) in
            if error != nil {
                print(error!)
                return
            }
        })

    }
    
    @IBAction func submitPressed(_ sender: AnyObject) {
        // display alert if user did not select two activities
        if self.selectedIndexes.count != 2{
            self.createAlert(titleText: "Error", messageText: "Please select two activities before continuing")
            return
        }
        
        var activityIds = [String]()
        for selection in self.selectedIndexes{
            // generate new id for each activity selection and then store it
            let activityRef = dbRef.child("Activities").childByAutoId()
            activityIds.append(activityRef.key)
            
            // store the image of the activity into array of selected activities for Sprint Setting Screen
            self.delegate.activitySelectedImages.append(self.delegate.joyImages[selection].uiImage.image!)
            
            // get name of the activity selected
            let name = self.delegate.joyImages[selection].name
            print("This is the name going to db : \(name)")
            
            // create a new Activity object to store in the database
            let newActivity = Activity(name: name, categoryId: self.delegate.categoryKey, userId: self.delegate.user
                .id)
            // Activity object is stored in the database
            activityRef.setValue(newActivity.toAnyObject(), withCompletionBlock: {(error,activityRef) in
                if error != nil{
                    print(error!)
                    return
                }
            })
        }
        
        // set a reference to JoySprints and create a new record
        let userCategoryRef = dbRef.child("Categories/\(self.delegate.categoryKey)/JoySprints").childByAutoId()
        
        // create a new Sprint object to store in the database
        let newSprint = Sprint(categoryId: self.delegate.categoryKey, sprintActivityId1: activityIds[0], sprintActivityId2: activityIds[1])
        
        print("This is Joy Sprint id : \(userCategoryRef.key)")
        
        // Sprint object is stored in the database
        userCategoryRef.setValue(newSprint.toAnyObject(), withCompletionBlock: {(error, userCategoryRef) in
            if error != nil{
                print(error!)
                return
            }
        })
        
        // selection is valid set the flag to true, the segue will execute next
        self.selectionIsValid = true
        
        // continue to the next activity selection
        performSegue(withIdentifier: "PassionActivitySelectionSegue", sender: self)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool{
        /* check if the user selected two activities and it was successfully stored UIViewController
           database before moving to the next category activity selection */
        if self.selectionIsValid{
            return true
        }
        return false
    }

}
