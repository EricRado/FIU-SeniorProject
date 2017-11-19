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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        coachImage.layer.cornerRadius = coachImage.frame.size.width / 2
        coachImage.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
