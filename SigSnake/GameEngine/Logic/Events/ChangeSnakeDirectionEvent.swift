//
//  ChangeSnakeDirectionEvent.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/17/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

class ChangeSnakeDirectionEvent : SnakeEvent {
    var direction:Direction
    
    init(controller: GameController, snake:Snake, direction:Direction) {
        self.direction = direction
        
        super.init(controller: controller, snake:snake)
    }
}
