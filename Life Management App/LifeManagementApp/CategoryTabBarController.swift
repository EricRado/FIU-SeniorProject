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
        
        let joyVC = storyboard.instantiateViewController(withIdentifier: "joyVC")
        let passionVC = storyboard.instantiateViewController(withIdentifier: "passionVC")
        let contributionVC = storyboard.instantiateViewController(withIdentifier: "contributionVC")
        let testerVC = storyboard.instantiateViewController(withIdentifier: "emotionVC")
        object_setClass(testerVC, Test1VC.self)
        testerVC.title = "Test"
        
        let viewControllersList = [joyVC, passionVC, contributionVC, testerVC]
        
        viewControllers = viewControllersList.map {
            UINavigationController(rootViewController: $0)
        }
    }


}
