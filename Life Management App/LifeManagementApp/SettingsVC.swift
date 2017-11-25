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
    let delegate = UIApplication.shared.delegate as! AppDelegate
    let dbref = Database.database().reference(fromURL: "https://life-management-v2.firebaseio.com/")
    var userRef = DatabaseReference()
    let imageManager = ImageManager()
    
    @IBOutlet weak var userUploadImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userRef = dbref.child("Users/\(delegate.user.id)")

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func uploadImagePressed(_ sender: UIButton) {
        
        let image = UIImagePickerController()
        image.delegate = self
        
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        image.allowsEditing = false
        
        self.present(image, animated: true){
            // After it is complete
            self.getUserProfileImg()
        }
        
    }
    
    func getUserProfileImg(){
        imageManager.downloadImage(user: delegate.user)
        delegate.userImgProfile = imageManager.downloadedImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            self.imageManager.uploadImage(user: delegate.user, image, progressBlock: {(percentage) in
                print(percentage)
            }, completionBlock: {(fileURL, errorMessage) in
                // update user with file path to user profile image
                if let url = fileURL?.absoluteString{
                    print("THIS IS THE URL : \(url)")
                    self.userRef.updateChildValues(["imgURL": url])

                }
                
            })
            
            userUploadImage.image = image
            
            // download new image to display in side menu
            let imageRef = storage.reference().child("userProfileImgs/\(self.imageManager.uploadImgName)")
            imageRef.getData(maxSize: 1 * 1024 * 1024, completion: {(data, error) in
                if let error = error{
                    print(error.localizedDescription)
                }else{
                    self.delegate.userImgProfile = UIImage(data: data!)!
                }
            })
        
        }else{
            // Error message
            print("Image was not able to load.")
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
