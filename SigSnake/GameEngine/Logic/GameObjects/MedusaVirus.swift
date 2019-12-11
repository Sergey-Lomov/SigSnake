//
//  MedusaVirus.swift
//  SigSnake
//
//  Created by Sergey Lomov on 6/14/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

class MedusaVirus : AttachableObject, PointInitialisable {
    static let group = "MedusaVirusGroup"
    
    var incubationStep = Constants.defaultIncubationStep
    var incubationProgress:Float = 0
    
    required init(point: Point) {
        let mainTimer = RealtimeTimer.infinityTimer
        let attachTimer = RealtimeTimer.infinityTimer
        super.init(point: point,
                   lifeTimer: mainTimer,
                   attachLifeTimer: attachTimer)
        
        direction = .fromTailToHead
        group = MedusaVirus.group
        incubationProgress = Constants.defaultIncubationStep
    }
    
    override func iterateStep() {
        super.iterateStep()
        
        if isAttached {
            if incubationProgress == 1 {
                produceVirus()
            }
            incubationProgress = (incubationProgress + incubationStep).normalise()
        }
    }
    
    override func execute(bySnake snake: Snake) {
        if !isSnakeInfected(snake) {
            super.execute(bySnake: snake)
        } else {
            let eatSelf = self.snake?.isEqual(snake) ?? false
            if !eatSelf {
                controller?.removeObject(self)
            }
        }
    }
    
    override func addAttachedEffect() {
        guard let controller = controller,
            let snake = snake else {return}

        var effect = existingInfectionEffect()
        if effect == nil {
            effect = MedusaInfectionEffect.init(controller: controller,
                                            snake: snake)
        }
        
        effect?.addReason(self)
    }
    
    override func removeAttachedEffect() {
        existingInfectionEffect()?.removeReason(self)
    }
    
    override func hasBeenAdded(_ controller: GameController) {
        super.hasBeenAdded(controller)
        
        var effect = existingColonyEffect()
        if effect == nil {
            effect = MedusaColonyEffect(controller: controller)
        }
        
        effect?.addReason(self)
    }
    
    override func willBeRemoved() {
        super.willBeRemoved()
        existingColonyEffect()?.removeReason(self)
    }
    
    // MARK: Private
    private func existingInfectionEffect() -> MedusaInfectionEffect? {
        let effects:[MedusaInfectionEffect]? = snake?.eventMutatorsOfType()
        return effects?.first
    }
    
    private func existingColonyEffect() -> MedusaColonyEffect? {
        let effects:[MedusaColonyEffect]? = controller?.eventMutatorsOfType()
        return effects?.first
    }
    
    private func isSnakeInfected(_ snake:Snake) -> Bool {
        let effects:[MedusaInfectionEffect]? = snake.eventMutatorsOfType()
        return effects?.first != nil
    }
    
    private func forcedExecute(bySnake snake:Snake) {
        super.execute(bySnake: snake)
    }
    
    private func produceVirus () {
        guard let snake = snake,
            let prevSegment = segment?.previous else {return}
        
        if prevSegment == snake.head {
            killSnake(snake)
        } else {
            infectSegment(prevSegment)
        }
    }
    
    private func killSnake (_ snake:Snake) {
        guard let controller = controller else {return}
        
        let event = DieSnakeEvent(controller: controller,
                                  snake: snake,
                                  messageKey: Constants.dieMessageKey)
        controller.handleEvent(event)
    }
    
    private func infectSegment (_ segment:SnakeSegment) {
        guard let snake = segment.snake,
            let controller = controller else {return}
        
        let prevObjects = segment.attachedObjects
        if prevObjects[MedusaVirus.group] == nil {
            let newVirus = MedusaVirus(point: segment.point)
            controller.addObject(newVirus)
            newVirus.forcedExecute(bySnake: snake)
        }
    }
    
    // MARK: Constants
    struct Constants {
        static let defaultIncubationStep:Float = 0.2
        static let dieMessageKey = "dieByMedusaVirus"
    }
}
