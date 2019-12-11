//
//  Wall.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/8/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

class Wall: GameObject {
    var collisionMessageKey:String {return "wall_collision"}
    
    override func execute(bySnake snake:Snake) {
        guard let controller = controller else {return}
        
        let event = CollisionSnakeEvent(controller: controller,
                                        snake: snake,
                                        object: self,
                                        messsageKey: collisionMessageKey)
        controller.handleEvent(event)
    }
}
