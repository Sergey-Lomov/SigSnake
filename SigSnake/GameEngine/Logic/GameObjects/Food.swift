//
//  Food.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/9/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

class Food: TemporalObject {
    var value:Int
    
    init(point:Point,
         value:Int = Constants.defaultValue,
         lifeTimer:GameTimer = RealtimeTimer.infinityTimer) {
        
        self.value = value
        super.init(point: point, lifeTimer: lifeTimer)
    }
    
    override func execute(bySnake snake:Snake) {
        guard let controller = controller else {return}
        
        snake.addProlongation(value)
        controller.removeObject(self)
    }
    
    // MARK: Constants
    private struct Constants {
        static let defaultValue:Int = 1
    }
}
