//
//  StepsControllerFactory.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/10/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

class StepsControllerFactory {
    func defaultAcceleratedStepsController () -> StepsController {
        let initialDuration = Constants.defaultAccelerated.initialStepDuration
        let stepsController = AcceleratedStepsController(initialDuration: initialDuration)
        stepsController.autoAcceleration = Constants.defaultAccelerated.stepAcceleration
        stepsController.minDuration = Constants.defaultAccelerated.minStepDuration
        stepsController.maxDuration = Constants.defaultAccelerated.maxStepDuration
        
        return stepsController
    }
    
    // MARK: Private
    private struct Constants {
        struct defaultAccelerated {
            static let initialStepDuration:TimeInterval = 0.8
            static let minStepDuration:TimeInterval = 0.4
            static let maxStepDuration:TimeInterval = 1.2
            static let stepAcceleration:Double = 0.005
        }
    }
}
