//
//  DieSnakeEvent.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/19/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

class DieSnakeEvent : SnakeEvent {
    var messageKey:String
    
    init(controller: GameController, snake: Snake, messageKey:String) {
        self.messageKey = messageKey
        super.init(controller: controller, snake: snake)
    }
    
    init(fromCollision collision:CollisionSnakeEvent) {
        self.messageKey = collision.messsageKey
        super.init(controller: collision.controller, snake: collision.snake)
    }
    
    init(fromOutOfField outEvent:OutOfFieldSnakeEvent) {
        self.messageKey = outEvent.messsageKey
        super.init(controller: outEvent.controller, snake: outEvent.snake)
    }
}
