//
//  CorpseSegment.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/18/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

class CorpseSegment : TemporalObject {
    var collisionMessageKey:String {return "corpse_collision"}
    
    var timeLimit:TimeInterval
    
    init(point:Point,
         timeLimit:TimeInterval = Constants.defaultTimeLimit) {
        
        self.timeLimit = timeLimit
        let timer = RealtimeTimer(timeLimit: timeLimit)
        super.init(point: point, lifeTimer: timer)
    }
    
    override func execute(bySnake snake: Snake) {
        guard let controller = controller else {return}
        
        let event = CollisionSnakeEvent(controller: controller,
                                        snake: snake,
                                        object: self,
                                        messsageKey: collisionMessageKey)
        controller.handleEvent(event)
    }
    
    // MARK: Constants
    private struct Constants {
        static let defaultTimeLimit:TimeInterval = 25
    }
}
