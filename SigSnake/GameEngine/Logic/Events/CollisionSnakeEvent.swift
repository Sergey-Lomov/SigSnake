//
//  CollisionSnakeEvent.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/18/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

class CollisionSnakeEvent : SnakeEvent {
    var object:GameObject
    var messsageKey:String
    
    init(controller: GameController,
         snake: Snake,
         object:GameObject,
         messsageKey:String) {
        self.object = object
        self.messsageKey = messsageKey
        super.init(controller: controller, snake: snake)
    }
}
