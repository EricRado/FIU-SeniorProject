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

class CurrentChatsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let interactor = Interactor()
    var chats = [Chat]()
    var coaches = [Coach]()
    let delegate = UIApplication.shared.delegate as! AppDelegate
    let dbref = Database.database().reference(fromURL: "https://life-management-v2.firebaseio.com/")
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        getChats()
        
    }
    
    func getChats(){
        let chatRef = dbref.child("Chats")
        let chatQuery = chatRef.queryOrdered(byChild: "userId").queryEqual(toValue: delegate.user.id)
        chatQuery.observe(.value, with: {(snapshot) in
            print(snapshot)
            for child in snapshot.children.allObjects as! [DataSnapshot]{
                let chat = Chat(snapshot: child)
                if let chat = chat{
                    self.chats.append(chat)
                    self.getCoach(coachId: chat.coachId)
                    print(self.chats)
                }
            }
        }, withCancel: {(error) in
            print(error.localizedDescription)
        })
    }
    
    func getCoach(coachId: String){
        let coachRef = dbref.child("Coaches")
        let coachQuery = coachRef.queryOrdered(byChild: "id").queryEqual(toValue: coachId)
        coachQuery.observeSingleEvent(of: .value, with: {(snapshot) in
            print(snapshot)
            for child in snapshot.children.allObjects as! [DataSnapshot]{
                let coach = Coach(snapshot: child)
                if let coach = coach{
                    self.coaches.append(coach)
                    print(self.coaches)
                }
            }
            self.tableView.reloadData()
        }, withCancel: {(error) in
            print(error.localizedDescription)
        })
    }
    
    func getImage(url: String, cell : CurrentChatTableViewCell){
        let imageRef = storage.reference(forURL: url)
        
        imageRef.getData(maxSize: 1 * 1024 * 1024, completion: {data, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }else {
                cell.userProfileImg.image = UIImage(data: data!)
            }
        })
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "currentChatCell") as! CurrentChatTableViewCell
        
        cell.mostRecentMsgLabel.text = chats[indexPath.row].lastMessage
        let coach = coaches.filter({$0.id == chats[indexPath.row].coachId})
        if !coach.isEmpty{
            cell.nameLabel.text = "\(coach[0].firstName)  \(coach[0].lastName)"
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.getImage(url: coach[0].imgURL, cell: cell)
            })
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
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





