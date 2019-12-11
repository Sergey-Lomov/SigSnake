//
//  GameEvent.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/16/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

// Abstract base class for game events
class GameEvent {
    var controller:GameController
    var isEnable:Bool = true
    
    init (controller:GameController) {
        self.controller = controller
    }
}
