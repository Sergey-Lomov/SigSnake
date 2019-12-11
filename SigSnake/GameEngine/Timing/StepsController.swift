//
//  StepsController.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/10/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

// This class controll game steps, not animation/drawing frames

protocol StepsControllerDelegate {
    func stepForward()
}

protocol StepsController {
    var delegate:StepsControllerDelegate? {get set}
    
    var initialDuration:TimeInterval {get}
    var currentDuration:TimeInterval {get}
    var minDuration:TimeInterval? {get}
    var maxDuration:TimeInterval? {get}
    
    init(initialDuration:TimeInterval)
    
    func execute()
    func stop()
    func accelerate(_ acceleration:Float)
}

class AcceleratedStepsController : StepsController {
    var minDuration: TimeInterval? = nil
    var maxDuration: TimeInterval? = nil
    
    var delegate: StepsControllerDelegate?
    
    var initialDuration:TimeInterval
    var currentDuration:TimeInterval
    
    var autoAcceleration:Double = 0
    
    private var timer:Timer?
    
    required init(initialDuration: TimeInterval) {
        self.initialDuration = initialDuration
        self.currentDuration = initialDuration
    }
    
    func execute() {
        timer = Timer.scheduledTimer(withTimeInterval: currentDuration,
                                     repeats: false,
                                     block: { (_) in
                                        self.doStep()
        })
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
    }
    
    func accelerate(_ acceleration: Float) {
        let newValue = currentDuration * TimeInterval(acceleration)
        currentDuration = newValue.normalise(min: minDuration, max: maxDuration)
    }
    
    // MARK: Private
    private func doStep() {
        if timer == nil {return}
        
        let newDuration = currentDuration * (1 - autoAcceleration)
        currentDuration = newDuration.normalise(min: minDuration, max: maxDuration)
        delegate?.stepForward()
        execute()
    }
}
