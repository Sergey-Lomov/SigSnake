//
//  ControlInversionEffect.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/17/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

class ControlInversionEffect : SnakeEffect<GameObject> {
    
    override func mutateEvent(_ event: GameEvent) -> GameEvent {
        guard let move = event as? ChangeSnakeDirectionEvent,
            snake.isEqual(move.snake) else {
                return event
        }
        
        let headPoint = move.snake.head.point
        let newDirection = move.direction.opositeInPoint(headPoint)
        return ChangeSnakeDirectionEvent(controller: move.controller,
                                         snake: move.snake,
                                         direction: newDirection)
    }
}
