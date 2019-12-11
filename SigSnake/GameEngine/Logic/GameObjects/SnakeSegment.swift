//
//  SnakeBody.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/8/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

class SnakeSegment : GameObject {
    var snake:Snake?
    var next:SnakeSegment?
    var previous:SnakeSegment?
    
    /// Any segment of snake may have attached objects, transported at top of it. Attachable objects divides by groups (string ids). These groups uses like a key for attachable objects dictionary. One segment may have only one object of same group.
    var attachedObjects = [String:GameObject]()
    
    private let selfCollisionKey = "self_collision"
    private let enemyCollisionKey = "enemy_collision"
    
    override var point: Point {
        didSet {
            for object in attachedObjects.values {
                object.point = point
            }
        }
    }
    
    init(point: Point, snake:Snake? = nil) {
        self.snake = snake
        super.init(point: point)
    }
    
    override func execute(bySnake snake:Snake) {
        guard let selfSnake = self.snake,
            let controller = controller else {return}
        
        let messageKey = snake.isEqual(selfSnake) ? selfCollisionKey : enemyCollisionKey
        let event = CollisionSnakeEvent(controller: controller,
                                        snake: snake,
                                        object: self,
                                        messsageKey: messageKey)
        controller.handleEvent(event)
    }
}

class SnakeHead : SnakeSegment {
    var direction:Direction
    
    init(point:Point, snake:Snake? = nil, direction:Direction) {
        self.direction = direction
        super.init(point:point, snake:snake)
    }
}

class SnakeBody : SnakeSegment {
    override func execute(bySnake snake:Snake) {
        if self != snake.tail || snake.haveProlongation() {
            super.execute(bySnake: snake)
        }
    }
}
