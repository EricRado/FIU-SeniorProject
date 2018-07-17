//
//  AllExtensions.swift
//  LifeManagementApp
//
//  Created by Eric Rado on 5/14/18.
//  Copyright © 2018 SeniorProject. All rights reserved.
//

import Foundation
import UIKit
import Firebase


// dismisses keyboard when any part of the screen is tapped
extension UITextField{
    func setBottomLine(borderColor: UIColor) {
        
        self.borderStyle = UITextBorderStyle.none
        self.backgroundColor = UIColor.clear
        
        let borderLine = UIView()
        let height = 1.0
        borderLine.frame = CGRect(x: 0, y: Double(self.frame.height) - height,
                                  width: Double(self.frame.width),height: height)
        
        borderLine.backgroundColor = borderColor
        self.addSubview(borderLine)
    }
    
}

extension String {
    
    //Enables replacement of the character at a specified position within a string
    func replace(_ index: Int, _ newChar: Character) -> String {
        var chars = Array(characters)
        chars[index] = newChar
        let modifiedString = String(chars)
        return modifiedString
    }
}

extension UIView{
    
    func addConstraintsWithFormat(_ format: String, views: UIView...){
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated(){
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}

extension UIViewController{
    func hideKeyboardWhenTappedAround(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func createAlert(titleText: String, messageText: String){
        let alert = UIAlertController(title: titleText, message: messageText, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true)
    }
    
}

extension UIImageView {
    // get url for the activity image from snapshot
    func downloadActivityImg(url: DatabaseReference?) {
        if let url = url {
            url.observeSingleEvent(of: .childAdded, with: { (snapshot) in
                print("Download image url...")
                print(snapshot)
                
                // Get download URL from snapshot
                let downloadURL = snapshot.value as! String
                print(downloadURL)
                
                // Create a storage reference from the URL
                let storageReference = storage.reference(forURL: downloadURL)
                
                // Download the data, assuming a max size of 1MB
                storageReference.getData(maxSize: 1*1024*1024, completion: { (data, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    self.image = UIImage(data: data!)
                })
            }) { (error) in
                print(error.localizedDescription)
            }
        } else {
            print("Url does not exist")
        }
    }
}

// Adding a stored property to UIButton class

protocol PropertyStoring {
    associatedtype T
    
    func getAssociatedObject(_ key: UnsafeRawPointer!, defaultValue: T) -> T
}

extension PropertyStoring {
    func getAssociatedObject(_ key: UnsafeRawPointer!, defaultValue: T) ->T {
        guard let value = objc_getAssociatedObject(self, key) as? T else {
            return defaultValue
        }
        return value
    }
}

public enum Position {
    case Top
    case Bottom
    case NotApplicable
}

extension UIButton: PropertyStoring {
    typealias T = Position
    
    private struct CustomProperties {
        static var position = Position.NotApplicable
    }
    
    var position: Position {
        get {
            return getAssociatedObject(&CustomProperties.position, defaultValue: CustomProperties.position)
        }
        set {
            return objc_setAssociatedObject(self, &CustomProperties.position, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}


