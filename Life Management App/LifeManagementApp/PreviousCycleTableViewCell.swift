//
//  PreviousCycleTableViewCell.swift
//  LifeManagementApp
//
//  Created by Eric Rado on 11/9/17.
//  Copyright © 2017 SeniorProject. All rights reserved.
//

import UIKit

class PreviousCycleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var sprintDate: UILabel!
    @IBOutlet weak var joyOverallScore: UILabel!
    @IBOutlet weak var passionOverallScore: UILabel!
    @IBOutlet weak var contributionOverallScore: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


}
