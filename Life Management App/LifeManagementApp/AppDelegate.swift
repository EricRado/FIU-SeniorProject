//
//  AppDelegate.swift
//  LifeManagementApp
//
//  Created by Eric Rado on 9/4/17.
//  Copyright © 2017 SeniorProject. All rights reserved.
//

import UIKit
import Firebase

// get a reference to the storage service using the firebase app
let storage = Storage.storage()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    static var menu_bool = true
    
    // load images from database to corresponding array
    var joyImages = [ActivityImage]()
    var passionImages = [ActivityImage]()
    var contributionImages = [ActivityImage]()
    
    // store activities image selected to display on Sprint Settings Screen
    var activitySelectedImages = [UIImage]()
    
    // store user currently online and their category collection key
    var user = User()
    var categoryKey = ""
    var userImgProfile = UIImage()
    
    var imgDbRef: DatabaseReference? = nil
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        imgDbRef = Database.database().reference(fromURL: "https://life-management-v2.firebaseio.com/")
        self.getImgURLS(option: "Joy")
        self.getImgURLS(option: "Passion")
        self.getImgURLS(option: "Contribution")
        
        // set the navigation bar color
        UINavigationBar.appearance().tintColor = UIColor.white
        
        // set the navigation bar title text color
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]

        return true
    }
    
    func getImgURLS(option: String){
        // get reference to specific category picture collection in firebase
        let specificImgCategoryRef = self.imgDbRef?.child("ActivityImgs/\(option)Activities/")
        
        // from the snapshot, use every URL found to get image from firebase storage
        specificImgCategoryRef?.observe(.value, with: {(snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot]{
                self.getImg(snapshot: child, option: option)
            }
        })
    }
    
    func getImg(snapshot: DataSnapshot, option: String){
        var dict = snapshot.value as? [String: Any]
        if let url = dict?["url"] as? String {
            // get image with url from storage
            let imgRef = storage.reference(forURL: url)
            
            imgRef.getData(maxSize: 1 * 1024 * 1024, completion: {data,error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }else {
                    let name = dict?["name"] as? String
                    let imageview = UIImageView()
                    
                    // store image retrieved into a UIImageView
                    imageview.image = UIImage(data:data!)
                    let img = ActivityImage(name: name!, uiImage: imageview)
                    
                    // store the image by its corresponding category
                    if option == "Joy"{
                        self.joyImages.append(img)
                    }else if(option == "Passion"){
                        self.passionImages.append(img)
                    }else{
                        self.contributionImages.append(img)
                    }
                }
            })
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

