//
//  AttachableObject.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/11/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

enum AttachDirection {
    case fromHeadToTail, fromTailToHead
}

class AttachableObject : TemporalObject {
    static let defaultGroup = "DefaultGroup"
    
    var mainLifeTimer:GameTimer
    var attachLifeTimer:GameTimer
    
    var segment:SnakeSegment?
    var snake:Snake? {return segment?.snake}
    var isAttached:Bool {return segment != nil}
    
    /// Defines group of object. Default snake may have few attached object in one segment from different groups. But not from one group.
    var group:String = AttachableObject.defaultGroup
    var direction:AttachDirection = .fromHeadToTail
    
    init(point:Point, lifeTimer:GameTimer, attachLifeTimer:GameTimer) {
        self.attachLifeTimer = attachLifeTimer
        self.mainLifeTimer = lifeTimer
        super.init(point:point, lifeTimer: lifeTimer)
    }
    
    override func execute(bySnake snake: Snake) {
        // Snake have no possbility to execute object which already attached to it
        let eatSelf = self.snake?.isEqual(snake) ?? false
        if eatSelf {return}
        
        if let segment = snake.attachObject(self) {
            self.segment = segment
            point = segment.point
            addAttachedEffect()
            switchToLifetimer(attachLifeTimer)
        }
    }
    
    override func willBeRemoved() {
        super.willBeRemoved()
        removeAttachedEffect()
    }
    
    func unattach () {
        switchToLifetimer(mainLifeTimer)
        removeAttachedEffect()
        segment = nil
    }
    
    // This methods should be overrided in derived objects
    func addAttachedEffect() {}
    
    func removeAttachedEffect() {}
    
    // MARK: Private
    private func switchToLifetimer(_ newTimer:GameTimer) {
        newTimer.reset()
        newTimer.pauseManager.getReasonsFrom(lifeTimer.pauseManager)
        newTimer.start()
        lifeTimer = newTimer
    }
}
