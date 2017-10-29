//
//  Popup3VC.swift
//  LifeManagementApp
//
//  Created by Eric Rado on 9/13/17.
//  Copyright © 2017 SeniorProject. All rights reserved.
//

import UIKit

class Popup3VC: UIViewController {
    
    
    @IBOutlet weak var popupView3: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popupView3.layer.cornerRadius = 10
        popupView3.layer.masksToBounds = true
        
    }
    
    @IBAction func closePopup3(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
}
