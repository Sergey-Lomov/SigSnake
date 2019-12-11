//
//  SnakeEvent.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/18/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

// Abstract base class for snake events
class SnakeEvent : GameEvent {
    var snake:Snake
    
    init (controller:GameController, snake:Snake) {
        self.snake = snake
        super.init(controller: controller)
    }
}
