//
//  GameObjectDrawer.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/11/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation
import UIKit

class GameObjectDrawer : Drawer {
    required init?(entity: Any, colorMap: ColorMap, mapper:GeometryMapper) {
        super.init(entity: entity, colorMap: colorMap, mapper: mapper)
        
        topLayer.zPosition = GameObjectDrawersZGroup.inField.rawValue
        enableDeviders()
        update()
    }
    
    override func createLayer() -> CALayer {
        guard let object = entity as? GameObject else {
            return super.createLayer()
        }
        
        return mapper.layer(forPoint: object.point)
    }
    
    override func update() {
        guard let object = entity as? GameObject else {return}
        topLayer.position = mapper.pointCenterPosition(object.point)
    }
    
    func pauseAnimation() {
        let pausedTime = topLayer.convertTime(CACurrentMediaTime(), from: nil)
        topLayer.speed = 0.0
        topLayer.timeOffset = pausedTime
    }
    
    func resumeAnimation() {
        let pausedTime = topLayer.timeOffset
        topLayer.speed = 1.0
        topLayer.timeOffset = 0.0
        topLayer.beginTime = 0.0
        let relativeTime = topLayer.convertTime(CACurrentMediaTime(), from: nil)
        let timeSincePause = relativeTime - pausedTime
        topLayer.beginTime = timeSincePause
    }
    
    func setBackgroundColor(_ color:CGColor?) {
        if let shape = layer as? CAShapeLayer {
            shape.fillColor = color
        } else {
            layer.backgroundColor = color
        }
    }
    
    func enableDeviders () {
        if let shape = layer as? CAShapeLayer {
            shape.strokeColor = colorMap.outfieldColor.cgColor
        } else {
            layer.backgroundColor = colorMap.outfieldColor.cgColor
        }
    }
    
    func disableDeviders () {
        if let shape = layer as? CAShapeLayer {
            shape.strokeColor = UIColor.clear.cgColor
        } else {
            layer.backgroundColor = UIColor.clear.cgColor
        }
    }
    
}
