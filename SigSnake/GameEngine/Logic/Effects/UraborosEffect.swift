//
//  UraborosEffect.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/19/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

class UraborosEffect : SnakeEffect<GameObject> {
    override func mutateEvent(_ event: GameEvent) -> GameEvent {
        guard let collision = event as? CollisionSnakeEvent,
            snake.isEqual(collision.snake) else {
                return event
        }
        
        guard let snakeSegment = collision.object as? SnakeSegment else {return event}
        let cutEvent = CutSnakeEvent(controller: collision.controller,
                                     snake: collision.snake,
                                     segment: snakeSegment)
        
        if let firstReason = reasonsManager.firstReason {
            removeReason(firstReason)
            controller.removeObject(firstReason)
        }
        
        return cutEvent
    }
}
