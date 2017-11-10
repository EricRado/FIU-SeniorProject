//
//  PreviousCycleVC.swift
//  LifeManagementApp
//
//  Created by Eric Rado on 11/9/17.
//  Copyright © 2017 SeniorProject. All rights reserved.
//

import UIKit
import Firebase

class PreviousCycleVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var dbref = Database.database().reference(fromURL: "https://life-management-f0cdf.firebaseio.com/")
    var delegate = UIApplication.shared.delegate as! AppDelegate
    var userCategory = Category()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "summaryCell") as! PreviousCycleTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
