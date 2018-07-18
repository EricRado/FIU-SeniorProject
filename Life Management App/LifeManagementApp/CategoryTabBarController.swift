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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        

        let joyVC = storyboard.instantiateViewController(withIdentifier: "emotionVC")
        object_setClass(joyVC, JoyVC.self)
        joyVC.title = "Joy"
        
        let passionVC = storyboard.instantiateViewController(withIdentifier: "emotionVC")
        object_setClass(passionVC, PassionVC.self)
        passionVC.title = "Passion"
        
        let contributionVC = storyboard.instantiateViewController(withIdentifier: "emotionVC")
        object_setClass(contributionVC, ContributionVC.self)
        contributionVC.title = "Contribution"
        
        let viewControllersList = [joyVC, passionVC, contributionVC]
        
        viewControllers = viewControllersList.map {
            UINavigationController(rootViewController: $0)
        }
    }


}
