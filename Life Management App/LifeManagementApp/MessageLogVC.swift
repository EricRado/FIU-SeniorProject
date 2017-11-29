//
//  MessageLogVC.swift
//  LifeManagementApp
//
//  Created by Eric Rado on 11/28/17.
//  Copyright © 2017 SeniorProject. All rights reserved.
//

import UIKit

class MessageLogVC: UIViewController {
    var recipient = Coach()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "\(recipient.firstName)"
    }

}
