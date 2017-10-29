//
//  Popup5VC.swift
//  LifeManagementApp
//
//  Created by Eric Rado on 9/13/17.
//  Copyright © 2017 SeniorProject. All rights reserved.
//

import UIKit

class Popup5VC: UIViewController {
    
    @IBOutlet weak var popupView5: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popupView5.layer.cornerRadius = 10
        popupView5.layer.masksToBounds = true
        
    }
    
    
    @IBAction func closePopup5(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
}
