//
//  Accelerator.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/14/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

// Deceleration is acceleration with coefficient less than 1
class Accelerator : TemporalObject {
    // Define liemits for coefficient.
    // Available range is from 1 - maxPower to 1 + maxPower exclude range from 1 - minPower to 1 + minPower
    static let maxPower:Float = 0.35
    static let minPower:Float = 0.1
    
    var coefficient: Float
    // Power of acceleration/deceleration in ragne from 0 to 1 (max power)
    var power: Float {
        let diff = Accelerator.maxPower - Accelerator.minPower
        let relativePower = abs(1 - coefficient) - Accelerator.minPower
        return relativePower / diff
    }
    
    init(point:Point, coefficient:Float) {
        let timer = RealtimeTimer(timeLimit: Constants.timeLimit)
        
        self.coefficient = coefficient
        super.init(point: point, lifeTimer: timer)
    }
    
    override func execute(bySnake snake: Snake) {
        guard let controller = controller else {return}
        
        controller.delegate?.requestStepsAcceleration(coefficient)
        controller.removeObject(self)
    }
    
    //MARK: Constants
    struct Constants {
        static let timeLimit:TimeInterval = 12
    }
}
