//
//  ViewCoachTableViewCell.swift
//  LifeManagementApp
//
//  Created by Eric Rado on 11/17/17.
//  Copyright © 2017 SeniorProject. All rights reserved.
//

import UIKit

class ViewCoachTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var coachImage: UIImageView!
    
    @IBOutlet weak var coachNameLabel: UILabel!
    @IBOutlet weak var skillsLabel: UILabel!
    @IBOutlet weak var successRateLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        coachImage.layer.cornerRadius = coachImage.frame.size.width / 2
        coachImage.clipsToBounds = true
        coachImage.layer.borderWidth = 2
        coachImage.layer.borderColor = UIColor.blue.cgColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
