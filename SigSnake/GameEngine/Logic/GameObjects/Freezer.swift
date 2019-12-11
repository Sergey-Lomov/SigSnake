//
//  Freezer.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/11/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

class Freezer : AttachableObject, PointInitialisable {
    required init(point: Point) {
        let mainTimer = RealtimeTimer(timeLimit: Constants.mainTimeLimit)
        let attachTimer = RealtimeTimer(timeLimit: Constants.attachedTimeLimit)
        super.init(point: point, lifeTimer: mainTimer, attachLifeTimer: attachTimer)
    }
    
    override func addAttachedEffect () {
        guard let controller = controller else {return}
        
        let effects:[FreezeEffect] = controller.eventMutatorsOfType()
        var effect = effects.first
        if effect == nil {
            effect = FreezeEffect(controller: controller)
        }

        effect?.addReason(self)
    }
    
    override func removeAttachedEffect () {
        guard let controller = controller else {return}
        
        let effects:[FreezeEffect] = controller.eventMutatorsOfType()
        effects.first?.removeReason(self)
    }
    
    // MARK: Constants
    private struct Constants {
        static let mainTimeLimit:TimeInterval = 10
        static let attachedTimeLimit:TimeInterval = 8
    }
}
