//
//  Popup6VC.swift
//  LifeManagementApp
//
//  Created by Eric Rado on 9/13/17.
//  Copyright © 2017 SeniorProject. All rights reserved.
//

import UIKit

class Popup6VC: UIViewController {
    
    @IBOutlet weak var popupView6: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popupView6.layer.cornerRadius = 10
        popupView6.layer.masksToBounds = true
        
    }
    
    
    @IBAction func closePopup6(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
}
