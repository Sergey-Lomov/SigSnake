//
//  AcceleratorDrawer.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/14/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation
import UIKit

class AcceleratorDarwer : TemporalObjectDrawer {
    private let jumpAnimationKey = "jump"
    
    private var directionLayer:CAShapeLayer?
    
    required init?(entity: Any, colorMap: ColorMap, mapper:GeometryMapper) {
        super.init(entity: entity, colorMap: colorMap, mapper: mapper)
        hidingDuration = Constants.hidingDuration
        
        addDirectionLayer()
        setColors()
        addLifeAnimation()
    }
    
    private func setColors () {
        guard let object = entity as? Accelerator else {return}
        
        let minColor = colorMap.minAccelerationColor
        let maxColor = colorMap.maxAccelerationColor
        let power = CGFloat(object.power)
        let color = minColor.gradientTo(maxColor, index: power)
        setBackgroundColor(color.cgColor)
        
        let directionMult = Constants.directionColorMult
        let directionColor = color.colorWith(noAlphaMultiplier: directionMult)
        directionLayer?.fillColor = directionColor.cgColor
    }
    
    private func addLifeAnimation () {
        guard let object = entity as? Accelerator else {return}
        
        let yDisplacement = layer.frame.height * Constants.displacementMult
        let upDirection = CGPoint(x:0, y:-yDisplacement)
        let downDirection = CGPoint(x:0, y:yDisplacement)
        let direction = object.coefficient > 1 ? upDirection : downDirection
        
        let animation = ObjectAnimationFactory().jumpAnimation(
            duration: Constants.duration,
            interval: Constants.interval,
            steps: Constants.steps,
            direction: direction)
        layer.add(animation, forKey: jumpAnimationKey)
    }
    
    private func addDirectionLayer () {
        guard let object = entity as? Accelerator else {return}
        
        let upRotation = CGFloat(-90).degreesToRadians
        let downRotation = CGFloat(90).degreesToRadians
        let rotation = object.coefficient > 1 ? downRotation : upRotation
        
        let directionLayer = CAShapeLayer()
        let halfWidth = layer.frame.width / 2
        let halfHeight = layer.frame.height / 2
        directionLayer.frame.size = CGSize(width: halfWidth, height: halfHeight)
        directionLayer.position = CGPoint(x: halfWidth, y: halfHeight)
        
        let path = UIBezierPath.polygonPath(inRect: directionLayer.frame,
                                            verticesCount: 3,
                                            rotation: rotation)
        directionLayer.path = path.cgPath
        
        layer.addSublayer(directionLayer)
        self.directionLayer = directionLayer
    }
    
    // MARK: Constants
    private struct Constants {
        static let displacementMult:CGFloat = 0.4
        static let directionColorMult:CGFloat = 0.5
        static let duration:TimeInterval = 1
        static let interval:TimeInterval = 0.5
        static let steps:Int = 3
        static let hidingDuration:TimeInterval = 4
    }
}
