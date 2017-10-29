//
//  Popup4VC.swift
//  LifeManagementApp
//
//  Created by Eric Rado on 9/13/17.
//  Copyright © 2017 SeniorProject. All rights reserved.
//

import UIKit

class Popup4VC: UIViewController {
    
    @IBOutlet weak var popupView4: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popupView4.layer.cornerRadius = 10
        popupView4.layer.masksToBounds = true
        
    }
    
    @IBAction func closePopup4(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
