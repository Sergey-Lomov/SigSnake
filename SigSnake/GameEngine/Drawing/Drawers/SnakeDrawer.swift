//
//  SnakeDrawer.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/10/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation
import UIKit

class SnakeDrawer : Drawer {
    private var headDrawer:SnakeHeadDrawer
    private var bodyDrawers = Dictionary<SnakeBody, SnakeBodyDrawer>()
    
    required init?(entity: Any, colorMap: ColorMap, mapper:GeometryMapper) {
        guard let snake = entity as? Snake,
            let drawer = SnakeHeadDrawer(entity: snake.head, colorMap: colorMap, mapper: mapper)
            else {return nil}
        
        headDrawer = drawer
        
        super.init(entity: entity, colorMap: colorMap, mapper: mapper)

        layer.frame.size = mapper.fieldSize()
        layer.addSublayer(headDrawer.layer)
        update()
    }
    
    override func update() {
        guard let snake = entity as? Snake else {return}
        
        var newSegments = snake.body
        var unnecessaryPairs = bodyDrawers
        
        for segment in snake.body {
            if let drawer = bodyDrawers[segment] {
                newSegments.remove(object: segment)
                unnecessaryPairs.removeValue(forKey: segment)
                drawer.update()
            }
        }
        
        for segment in newSegments {
            addSegment(segment)
        }
        
        for segment in unnecessaryPairs.keys {
            removeSegment(segment)
        }
        
        headDrawer.update()
    }
    
    private func addSegment (_ segment:SnakeBody) {
        if let drawer = SnakeBodyDrawer(entity: segment, colorMap: colorMap, mapper: mapper) {
            bodyDrawers[segment] = drawer
            layer.addSublayer(drawer.layer)
        }
    }
    
    private func removeSegment(_ segment:SnakeBody) {
        let drawer = bodyDrawers[segment]
        drawer?.layer.removeFromSuperlayer()
        bodyDrawers.removeValue(forKey: segment)
    }
}
