//
//  ActivityImage.swift
//  LifeManagementApp
//
//  Created by Eric Rado on 10/20/17.
//  Copyright © 2017 SeniorProject. All rights reserved.
//

import Foundation

struct ActivityImage{
    var name: String
    var uiImage: UIImageView
    
    init(name: String, uiImage:UIImageView){
        self.name = name
        self.uiImage = uiImage
    }
    
}
