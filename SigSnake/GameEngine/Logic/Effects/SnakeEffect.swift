//
//  SnakeEffect.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/18/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

class SnakeEffect<ReasonType: Equatable> : GameEffect<ReasonType>, SnakeEventMutator {
    var snake: Snake
    
    init (controller:GameController, snake:Snake) {
        self.snake = snake
        super.init(controller: controller)
    }
    
    override func addToHolder() {
        snake.addEventMutator(self)
    }
}
