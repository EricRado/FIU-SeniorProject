//
//  SideMenuViewController.swift
//  LifeManagementApp
//
//  Created by Eric Rado on 10/30/17.
//  Copyright © 2017 SeniorProject. All rights reserved.
//

import UIKit
import Firebase

class SideMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // mainVC passes the interactor object to the sidemenuVC. This is how they share state
    var interactor: Interactor? = nil
    let imageManager = ImageManager()
    let delegate = UIApplication.shared.delegate as! AppDelegate
    let backgroundImage = UIImage(named: "backgroundSideMenu")
    
    var iconNameArr = [String]()
    var iconImage = [UIImage]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        iconNameArr = ["Top","Home","New Cycle","Previous Cycle", "View Coaches", "Share Progress","Messages", "Invite a Friend", "Settings", "Sign Out"]
        iconImage = [delegate.userImgProfile, UIImage(named: "home")!, UIImage(named: "newCycles")!, UIImage(named: "previousCycles")!, UIImage(named: "coachList")!, UIImage(named: "shareProgress")!, UIImage(named: "messages")!, UIImage(named: "inviteFriend")!, UIImage(named: "settings")!, UIImage(named: "signOut")!]
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // add a background view to the table view
        let backgroundImage = UIImage(named: "backgroundSideMenu")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return iconNameArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuTopTableViewCell") as! SideMenuTopTableViewCell
            cell.backgroundColor = UIColor.clear
            cell.nameLabel.text = "\(delegate.user.firstName) \(delegate.user.lastName)"
            cell.userProfileImg.image = delegate.userImgProfile
            cell.layoutIfNeeded()
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuTableViewCell") as! SideMenuTableViewCell
            cell.backgroundColor = UIColor.clear
            cell.iconNameLabel.text! = iconNameArr[indexPath.row]
        
            cell.iconImage.image = iconImage[indexPath.row]
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row >= 1{
            let cell = tableView.cellForRow(at: indexPath) as! SideMenuTableViewCell
            
            if cell.iconNameLabel.text! == "New Cycle"{
                self.performSegue(withIdentifier: "newCycleSegue", sender: self)
            }
            
            if cell.iconNameLabel.text! == "Previous Cycle"{
                self.performSegue(withIdentifier: "previousCycleSegue", sender: self)
            }
            
            if cell.iconNameLabel.text! == "View Coaches"{
                self.performSegue(withIdentifier: "viewCoachesSegue", sender: self)
            }
            
            if cell.iconNameLabel.text! == "Messages"{
                self.performSegue(withIdentifier: "viewChatsSegue", sender: self)
            }
            
            if cell.iconNameLabel.text! == "Settings"{
                self.performSegue(withIdentifier: "settingsSegue", sender: self)
            }
            
            if cell.iconNameLabel.text! == "Home"{
                self.performSegue(withIdentifier: "homeSegue", sender: self)
            }

        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 150
        }
        
        return 55
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
