//
//  OutOfFieldSnakeEvent.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/19/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

class OutOfFieldSnakeEvent : SnakeEvent {
    private static let defaultMessageKey = "outOfField"
    var messsageKey:String
    
    init(controller: GameController,
         snake: Snake,
         messsageKey:String = OutOfFieldSnakeEvent.defaultMessageKey) {
        self.messsageKey = messsageKey
        super.init(controller: controller, snake: snake)
    }
}
