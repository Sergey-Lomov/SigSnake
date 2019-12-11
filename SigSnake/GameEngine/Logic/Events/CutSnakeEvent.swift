//
//  CutSnakeEvent.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/19/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

class CutSnakeEvent : SnakeEvent {
    var segment : SnakeSegment
    
    init(controller: GameController, snake: Snake, segment : SnakeSegment) {
        self.segment = segment
        super.init(controller: controller, snake: snake)
    }
}
