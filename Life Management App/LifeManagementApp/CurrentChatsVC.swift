//
//  CurrentChatsVC.swift
//  LifeManagementApp
//
//  Created by Eric Rado on 11/21/17.
//  Copyright © 2017 SeniorProject. All rights reserved.
//

import UIKit
import Firebase

extension CurrentChatsVC: UIViewControllerTransitioningDelegate{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentMenuAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissMenuAnimator()
    }
    
    /* indicate that the dismiss transition is going to be interactive, but
     only if the user is panning */
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}

class CurrentChatsVC: UIViewController {
    
    let interactor = Interactor()

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    /***********************************************************
     
                        Side Menu Functions
     
     ***********************************************************/
    
    
    @IBAction func openMenu(_ sender: AnyObject){
        performSegue(withIdentifier: "openMenu", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? SideMenuViewController{
            destinationViewController.transitioningDelegate = self
            // pass the interactor object forward
            destinationViewController.interactor = interactor
        }
    }
    
    @IBAction func edgePanGesture(sender: UIScreenEdgePanGestureRecognizer){
        let translation = sender.translation(in: view)
        
        let progress = MenuHelper.calculateProgress(translationInView: translation, viewBounds: view.bounds, direction: .Right)
        
        MenuHelper.mapGestureStateToInteractor(gestureState: sender.state, progress: progress, interactor: interactor){
            self.performSegue(withIdentifier: "openMenu", sender: nil)
        }
    }

    

}





