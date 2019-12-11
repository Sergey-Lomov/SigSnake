//
//  Uraboros.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/19/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

class Uraboros : AttachableObject, PointInitialisable {
    required init(point: Point) {
        let mainTimer = RealtimeTimer(timeLimit: Constants.mainTimeLimit)
        let attachTimer = RealtimeTimer(timeLimit: Constants.attachTimeLimit)
        super.init(point: point, lifeTimer: mainTimer, attachLifeTimer: attachTimer)
    }
    
    override func addAttachedEffect () {
        guard let snake = self.snake,
            let controller = controller else {return}
        
        var effect = existingEffect()
        if effect == nil {
            effect = UraborosEffect.init(controller: controller,
                                         snake: snake)
        }
        
        effect?.addReason(self)
    }
    
    override func removeAttachedEffect () {
        existingEffect()?.removeReason(self)
    }
    
    private func existingEffect() -> UraborosEffect? {
        let effects:[UraborosEffect]? = snake?.eventMutatorsOfType()
        return effects?.first
    }
    
    // MARK: Constants
    private struct Constants {
        static let mainTimeLimit:TimeInterval = 15
        static let mainPreparation:TimeInterval = 4
        static let attachTimeLimit:TimeInterval = 20
        static let attachPreparation:TimeInterval = 5
    }
}
