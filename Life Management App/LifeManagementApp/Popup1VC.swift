//
//  Popup1VC.swift
//  LifeManagementApp
//
//  Created by Eric Rado on 9/12/17.
//  Copyright © 2017 SeniorProject. All rights reserved.
//

import UIKit

class Popup1VC: UIViewController {
    
    @IBOutlet weak var popupView1: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popupView1.layer.cornerRadius = 10
        popupView1.layer.masksToBounds = true
    }
    
    @IBAction func closePopup1(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
}
