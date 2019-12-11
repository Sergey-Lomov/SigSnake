//
//  TemporalObject.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/11/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

// This class is based for objects with fixed lifetime
class TemporalObject : GameObject {
    var lifeTimer:GameTimer
    
    init(point:Point, lifeTimer:GameTimer) {
        self.lifeTimer = lifeTimer
        super.init(point: point)
    }
    
    override func iterateStep() {
        guard let controller = controller else {return}
        
        super.iterateStep()
        
        if lifeTimer.isLeft() {
            controller.removeObject(self)
        }
    }
    
    override func hasBeenAdded(_ controller: GameController) {
        super.hasBeenAdded(controller)
        lifeTimer.start()
    }
}
