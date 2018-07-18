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
        
        let contributionVC = storyboard.instantiateViewController(withIdentifier: "contributionVC")
        let testerVC = storyboard.instantiateViewController(withIdentifier: "emotionVC")
        object_setClass(testerVC, Test1VC.self)
        testerVC.title = "Joy"
        
        let tester2VC = storyboard.instantiateViewController(withIdentifier: "emotionVC")
        object_setClass(tester2VC, Test2VC.self)
        tester2VC.title = "Passion"
        
        let tester3VC = storyboard.instantiateViewController(withIdentifier: "emotionVC")
        object_setClass(tester3VC, Test3VC.self)
        tester3VC.title = "Contribution"
        
        let viewControllersList = [testerVC, tester2VC, contributionVC, tester3VC]
        
        viewControllers = viewControllersList.map {
            UINavigationController(rootViewController: $0)
        }
    }


}
