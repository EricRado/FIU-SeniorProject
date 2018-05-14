//
//  ViewCoachesVC.swift
//  LifeManagementApp
//
//  Created by Eric Rado on 5/14/18.
//  Copyright © 2018 SeniorProject. All rights reserved.
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
    
    // MARK: - ViewController's variables
    
    let interactor = Interactor()
    
    var dbref = Database.database().reference(fromURL: "https://life-management-v2.firebaseio.com/")
    let delegate = UIApplication.shared.delegate as! AppDelegate
    var coachList = [Coach]()
    
    // MARK: - ViewController's IBOutlet variables
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - ViewController's Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        getCoaches()
    }
    
    // MARK: - Retrieve All Coaches information

    // retrieve all coaches information from firebase database
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
    
    // retrieve all coaches image profile from firebase storage
    func getCoachImage(url: String, cell : ViewCoachTableViewCell){
        let imageRef = storage.reference(forURL: url)
        
        imageRef.getData(maxSize: 1 * 1024 * 1024, completion: {data, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }else {
                cell.coachImage.image = UIImage(data: data!)
            }
        })
        
    }
    
    // MARK: - TableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.coachList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "coachCell") as! ViewCoachTableViewCell
        let coach = self.coachList[indexPath.row]
        cell.coachNameLabel.text = "\(coach.firstName) \(coach.lastName)"
        cell.skillsLabel.text = "\(coach.skills)"
        cell.successRateLabel.text = "\(coach.successRating)%"
        
        // get coach image from firebase storage
        if coach.imgURL != ""{
            getCoachImage(url: coach.imgURL, cell: cell)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Side Menu Methods
    
    @IBAction func openMenu(_ sender: UIButton){
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
