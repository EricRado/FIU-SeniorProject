//
//  CategoryTabBarController.swift
//  LifeManagementApp
//
//  Created by Eric Rado on 10/10/17.
//  Copyright © 2017 SeniorProject. All rights reserved.
//

import UIKit

class CategoryTabBarController: UITabBarController {
    
    
    
    var onlineUser:User = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("INSIDE TAB BAR CONTROLLER")
        print(onlineUser.firstName)

       // passing user to joy dashboard screen
        let joyNavController = self.viewControllers![0] as! UINavigationController
        let joyVC = joyNavController.topViewController as! JoyVC
        
        joyVC.onlineUser = self.onlineUser
    }


}
