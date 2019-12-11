//
//  FermentedYogurt.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/17/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

class FermentedYogurt : AttachableObject {
    init(point: Point) {
        let mainTimer = RealtimeTimer(timeLimit: Constants.mainTimeLimit)
        let attachTimer = RealtimeTimer(timeLimit: Constants.attachedTimeLimit)
        super.init(point: point, lifeTimer: mainTimer, attachLifeTimer: attachTimer)
    }
    
    override func addAttachedEffect () {
        guard let snake = self.snake,
            let controller = controller else {return}
        
        var effect = existingEffect()
        if effect == nil {
            effect = ControlInversionEffect.init(controller: controller,
                                                 snake: snake)
        }
        
        effect?.addReason(self)
    }
    
    override func removeAttachedEffect () {
        existingEffect()?.removeReason(self)
    }
    
    private func existingEffect() -> ControlInversionEffect? {
        guard let snake = self.snake else {return nil}
        let effects:[ControlInversionEffect] = snake.eventMutatorsOfType()
        return effects.first
    }
    
    // MARK: Constants
    private struct Constants {
        static let mainTimeLimit:TimeInterval = 120
        static let attachedTimeLimit:TimeInterval = 14
    }
}
