//
//  Popup2VC.swift
//  LifeManagementApp
//
//  Created by Eric Rado on 9/13/17.
//  Copyright © 2017 SeniorProject. All rights reserved.
//

import UIKit

class Popup2VC: UIViewController {
    
    
    @IBOutlet weak var popupView2: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popupView2.layer.cornerRadius = 10
        popupView2.layer.masksToBounds = true
    }
    
    @IBAction func closePopup2(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
}
