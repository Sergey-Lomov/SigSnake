//
//  SquareGeometry.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/24/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

class SquareGeometry : Geometry {
    
    func point(fromPoint point: Point,
               withDirection direction: Direction,
               inField field: Field) -> Point? {
        
        guard let point = point as? SquarePoint,
            let direction = direction as? SquareDirection,
            let field = field as? SquareField else {
                print("Try to use square geometry with no squre point, direction or field ")
                return nil
        }
        
        let resultX = point.x + direction.xDisplacement
        let resultY = point.y + direction.yDisplacement
        
        let resultPoint = SquarePoint(x: resultX, y: resultY)
        if !field.containsPoint(resultPoint) {
            return nil
        }
        
        return resultPoint
    }
    
    func circlePoints(center: Point,
                      radius: Int,
                      inField field: Field) -> [Point] {
        
        guard let center = center as? SquarePoint,
            let field = field as? SquareField else {
                print("Try to use square geometry with no squre point or field ")
                return []
        }
        
        var result = [Point]()
        
        let leftBorder = center.x - radius
        let rightBorder = center.x + radius
        let topBorder = center.y - radius
        let bottomBorder = center.y + radius
        
        for x in leftBorder...rightBorder {
            for y in topBorder...bottomBorder {
                let point = SquarePoint(x: x, y: y)
                if field.containsPoint(point) {
                    result.append(point)
                }
            }
        }
        
        return result
    }
    
    func points(forVertex vertex: Vertex, inField field: Field) -> [Point] {
        guard let vertex = vertex as? SquareVertex else {return []}
        
        let leftTop = SquarePoint(x: vertex.x - 1, y: vertex.y - 1)
        let rightTop = SquarePoint(x: vertex.x, y: vertex.y - 1)
        let leftBottom = SquarePoint(x: vertex.x - 1, y: vertex.y)
        let rightBottom = SquarePoint(x: vertex.x, y: vertex.y)
        
        var points = [leftTop, rightTop, leftBottom, rightBottom]
        points = points.filter({ point in
            return field.containsPoint(point)
        })
        
        return points
    }
    
    func vertices(forPoint point: Point, inField field: Field) -> [Vertex] {
        guard let point = point as? SquarePoint else {return []}
        
        let leftTop = SquareVertex(x: point.x, y: point.y)
        let rightTop = SquareVertex(x: point.x + 1, y: point.y)
        let leftBottom = SquareVertex(x: point.x, y: point.y + 1)
        let rightBottom = SquareVertex(x: point.x + 1, y: point.y + 1)
        
        return [leftTop, rightTop, leftBottom, rightBottom]
    }
}
