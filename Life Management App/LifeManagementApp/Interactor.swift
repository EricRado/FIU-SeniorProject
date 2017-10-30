//
//  Interactor.swift
//  LifeManagementApp
//
//  Created by Eric Rado on 10/30/17.
//  Copyright © 2017 SeniorProject. All rights reserved.
//

import Foundation
import UIKit

class Interactor: UIPercentDrivenInteractiveTransition {
    // indicates whether an interaction is underway
    var hasStarted = false
    
    // determines whether the interaction should complete, or roll back
    var shouldFinish = false
}
