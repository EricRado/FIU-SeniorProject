//
//  ViewCoachesVC.swift
//  LifeManagementApp
//
//  Created by Eric Rado on 11/17/17.
//  Copyright © 2017 SeniorProject. All rights reserved.
//

import UIKit
import Firebase

extension ViewCoachesVC: UIViewControllerTransitioningDelegate{
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



class ViewCoachesVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let interactor = Interactor()
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var dbref = Database.database().reference(fromURL: "https://life-management-v2.firebaseio.com/")
    let delegate = UIApplication.shared.delegate as! AppDelegate
    var coachList = [Coach]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        getCoaches()
        
    }
    
    func getCoaches(){
        let coachRef = dbref.child("Coaches")
        coachRef.observe(.value, with: {(snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot]{
                print(child)
                let coach = Coach(snapshot: child)
                if let newCoach = coach {
                    self.coachList.append(newCoach)
                    print(self.coachList)
                }
            }
            self.tableView.reloadData()
            
        }, withCancel: {(error) in
            print(error.localizedDescription)
        })
    }
    
    func getCoachImage(url: String) -> UIImage{
        let imageView = UIImageView()
        print("THIS IS URL... \(url)")
        let imageRef = storage.reference(forURL: url)
        imageRef.getData(maxSize: 1 * 1024 * 1024, completion: {data, error in
            if let error = error {
                print("GOT AN ERROR")
                print(error.localizedDescription)
                return
            }else {
                print("GETTING IMAGE...")
                imageView.image = UIImage(data: data!)
            }
        })
        return imageView.image!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.coachList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "coachCell") as! ViewCoachTableViewCell
        let coach = self.coachList[indexPath.row]
        cell.coachNameLabel.text = "\(coach.firstName) \(coach.lastName)"
        cell.skillsLabel.text = "\(coach.skills)"
        
        // get coach image from firebase storage
        if coach.imgURL != ""{
            cell.coachImage.image = getCoachImage(url: coach.imgURL)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
