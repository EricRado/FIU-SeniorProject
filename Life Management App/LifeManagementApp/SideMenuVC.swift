//
//  SideMenuVC.swift
//  LifeManagementApp
//
//  Created by Eric Rado on 10/2/17.
//  Copyright © 2017 SeniorProject. All rights reserved.
//

import UIKit

class SideMenuVC: UIViewController,UITableViewDelegate, UITableViewDataSource{

    let titleArray = ["New Cycle", "Current Cycle", "Previous Cycle", "Settings", "View Coaches","Share Progess",
                      "Chat", "Invite a Friend"]
    @IBOutlet weak var menuTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuTableView.delegate = self
        menuTableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sideMenuCell") as! SideMenuTableViewCell
        
        cell.titleLabel.text = titleArray[indexPath.row]
        return cell
    }
    
}
