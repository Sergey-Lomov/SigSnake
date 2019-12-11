//
//  SensorViewFactory.swift
//  SigSnake
//
//  Created by Sergey Lomov on 6/26/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation
import UIKit

enum SensorType {
    case fixed, movable, full
}

class SensorViewFactory {
    private let movableBehavior:PositionHandlingBehavior = {
        sensor, point, canvas in
        
        let superview = sensor.superview
        let translatedPoint = canvas.convert(point, to: superview)
        sensor.center = translatedPoint
    }
    
    private let rotatableBehavior:PositionHandlingBehavior = {
        sensor, point, canvas in
        // TODO: Coming soon
    }
    
    func sensorFor (game:GameController, snake:Snake, type:SensorType, canvas:UIView) -> SensorView {
        let geometry = game.geometry
        let behavior = behaviorFor(geometry: geometry, type: type)
        let frame = frameFor(type:type, canvas:canvas)
        
        var sensor = SensorView(frame: frame)
        if type == .fixed {
            sensor = segmentedSensor(frame: frame, geometry: geometry)
        }
        
        sensor.snakePositionHandling = behavior
        sensor.snake = snake
        
        return sensor
    }
    
    // MARK: Private
    private func frameFor(type:SensorType, canvas:UIView) -> CGRect {
        var frame = CGRect.zero
        if type == .movable {
            frame.size = CGSize(width: canvas.bounds.width * 2,
                                height: canvas.bounds.height * 2)
            frame.origin = CGPoint(x: -canvas.bounds.width / 2,
                                   y: -canvas.bounds.width / 2)
        } else if type == .full {
            frame.size = canvas.frame.size
        }
        
        return frame
    }
    
    private func behaviorFor(geometry:Geometry, type:SensorType) -> [PositionHandlingBehavior] {
        var behavoirs = [PositionHandlingBehavior]()
        // TODO: Add check for disk geometry and adding rotatableBehavior
        
        if type == .movable {
            behavoirs.append(movableBehavior)
        }
        
        return behavoirs
    }
    
    private func segmentsCountFor(geometry: Geometry) -> UInt {
        if geometry is SquareGeometry {
            return 4
        } else if geometry is HexagonGeometry {
            return 6
        }
        
        return 0
    }
    
    private func segmentedSensor(frame:CGRect, geometry:Geometry) -> SensorView {
        let segmentedSensor = SegmentedSensorView(frame: frame)
        segmentedSensor.segmentsCount = segmentsCountFor(geometry: geometry)
        segmentedSensor.centerColor = Constants.Segmented.centerColor
        segmentedSensor.sideColor = Constants.Segmented.sideColor
        segmentedSensor.borderColor = Constants.Segmented.borderColor
        
        return segmentedSensor
    }
    
    // MARK: Constants
    struct Constants {
        struct Segmented {
            static let centerColor = UIColor.red
            static let sideColor = UIColor.red.colorWith(noAlphaMultiplier: 0.6)
            static let borderColor = UIColor.rgbBlack
        }
    }
}
