//
//  SettingsVC.swift
//  LifeManagementApp
//
//  Created by Eric Rado on 11/24/17.
//  Copyright © 2017 SeniorProject. All rights reserved.
//

import UIKit
import Firebase

extension SettingsVC: UIViewControllerTransitioningDelegate{
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


class SettingsVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    let interactor = Interactor()
    
    @IBOutlet weak var userUploadImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func uploadImagePressed(_ sender: UIButton) {
        
        let image = UIImagePickerController()
        image.delegate = self
        
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        image.allowsEditing = false
        
        self.present(image, animated: true){
            // After it is complete
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            userUploadImage.image = image
        }else{
            // Error message
        }
        
        self.dismiss(animated: true, completion: nil)
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
