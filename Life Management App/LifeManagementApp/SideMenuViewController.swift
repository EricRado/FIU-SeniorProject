//
//  SideMenuViewController.swift
//  LifeManagementApp
//
//  Created by Eric Rado on 10/30/17.
//  Copyright © 2017 SeniorProject. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController {
    // mainVC passes the interactor object to the sidemenuVC. This is how they share state
    var interactor: Interactor? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func handleGesture(sender: UIPanGestureRecognizer){
        // you use translation(in: view) to get the pan gesture coordinates
        let translation = sender.translation(in: view)
        
        // using MenuHelper's calculateProgress() method, you convert the coordinates
        // into progress in a specific direction
        let progress = MenuHelper.calculateProgress(translationInView: translation, viewBounds: view.bounds, direction: .Left)
        
        // does the work of syncing the gesture state with the interactive transition
        MenuHelper.mapGestureStateToInteractor(gestureState: sender.state, progress: progress, interactor: interactor){
            self.dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func closeMenu(_ sender: AnyObject){
        dismiss(animated: true, completion: nil)
    }
}
