//
//  TemporalObjectDrawer.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/11/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation
import UIKit

class TemporalObjectDrawer : GameObjectDrawer {
    var temporalWrapperLayer:CALayer
    override var topLayer: CALayer {return temporalWrapperLayer}
    
    private let hidingAnimationKey = "lifetimeHiding"
    private var wasPaused:Bool
    
    var hidingDuration:TimeInterval = 0
    
    required init?(entity: Any, colorMap: ColorMap, mapper:GeometryMapper) {
        guard let object = entity as? TemporalObject else {return nil}
        wasPaused = object.lifeTimer.isPaused
        
        temporalWrapperLayer = CALayer()
        
        super.init(entity: entity, colorMap: colorMap, mapper: mapper)
        
        temporalWrapperLayer.frame = super.topLayer.frame
        super.topLayer.frame.origin = CGPoint.zero
        temporalWrapperLayer.addSublayer(super.topLayer)
        
        update()
    }
    
    override func update() {
        super.update()
        guard let object = entity as? TemporalObject else {return}
        
        if wasPaused != object.lifeTimer.isPaused {
            object.lifeTimer.isPaused ? pauseAnimation() : resumeAnimation()
            wasPaused = object.lifeTimer.isPaused
        }
        
        // Every update recreate hiding animation. This is necessary, because timer duration may changed between updates. Some timers related to games steps duration and e.t.c. Pause also require this solution.
        layer.removeAnimation(forKey: hidingAnimationKey)
        let timeLeft = object.lifeTimer.timeLeft()
        if timeLeft < hidingDuration {
            addHidingAnimation(timeLeft: timeLeft)
        }
    }
    
    func addHidingAnimation(timeLeft: TimeInterval) {
        let factory = ObjectAnimationFactory()
        let _ = factory.addOpacityStateChangeAnimation(duration: timeLeft,
                                                       type: .hide,
                                                       toLayer: layer,
                                                       key: hidingAnimationKey)
    }
}
