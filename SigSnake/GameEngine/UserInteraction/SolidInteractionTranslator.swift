//
//  SolidInteractionTranslator.swift
//  SigSnake
//
//  Created by Sergey Lomov on 6/21/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

/// Base class for all user interaction translators, which work on solid geometries: square, hexagon, disk. Graph geometry is not solid.
class SolidInteractionTranslator : UserInteractionGeometryTranslator {
    
    struct Limit {
        var min:Float
        var max:Float
    }
    
    struct DirectionLimit {
        var direction:Direction
        var limit:Limit
    }
    
    var directionsLimits:[DirectionLimit]
    var defaultDirection:Direction
    
    init(limits:[DirectionLimit], defaultDirection:Direction) {
        self.directionsLimits = limits
        self.defaultDirection = defaultDirection
    }
    
    func directionForAngle(_ angle: Float, point: Point, field: Field) -> Direction {
        var localAngle = angle.truncatingRemainder(dividingBy: .pi * 2)
        localAngle = localAngle >= 0 ? localAngle : .pi * 2 + localAngle
            
        for directionLimit in directionsLimits {
            let limit = directionLimit.limit
            if localAngle >= limit.min && localAngle <= limit.max {
                return directionLimit.direction
            }
        }
        
        return defaultDirection
    }
}

