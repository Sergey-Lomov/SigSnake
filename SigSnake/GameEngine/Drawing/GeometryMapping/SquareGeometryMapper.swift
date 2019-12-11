//
//  SquareGeometryMapper.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/29/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation
import UIKit

class SquareGeometryMapper : GeometryMapper {
    var geometry: Geometry {return SquareGeometry()}
    
    private var nodeSize:CGSize
    private var field:SquareField
    
    required init?(field:Field, canvasSize:CGSize) {
        guard let squareField = field as? SquareField else {return nil}
        
        self.field = squareField
        
        let width = floor(canvasSize.width / CGFloat(squareField.width))
        let height = floor(canvasSize.height / CGFloat(squareField.height))
        nodeSize = CGSize(width: width, height: height)
    }
    
    func fieldSize() -> CGSize {
        let width = nodeSize.width * CGFloat(field.width)
        let height = nodeSize.height * CGFloat(field.height)
        return CGSize(width: width, height: height)
    }
    
    func layer(forPoint point:Point) -> CALayer {
        let layer = CALayer()
        layer.frame.size = nodeSize
        layer.position = pointCenterPosition(point)
        return layer
    }
    
    func layerStrokeLenght() -> CGFloat {
        return nodeSize.width * 2 + nodeSize.height * 2
    }
    
    func pointCenterPosition(_ point:Point) -> CGPoint {
        let origin = pointOrigin(point)
        
        let centerX = origin.x + nodeSize.width / 2
        let centerY = origin.y + nodeSize.height / 2
        
        return CGPoint(x: centerX, y: centerY)
    }
    
    func pointOrigin(_ point: Point) -> CGPoint {
        guard let squarePoint = point as? SquarePoint else {return CGPoint.zero}
        
        let originX = CGFloat(squarePoint.x)
        let originY = CGFloat(squarePoint.y)
        return CGPoint(x: originX * nodeSize.width,
                       y: originY * nodeSize.height)
    }
    
    func vertexOrigin(_ vertex: Vertex) -> CGPoint {
        guard let vertex = vertex as? SquareVertex else {return CGPoint.zero}
        
        let x = CGFloat(vertex.x) * nodeSize.width
        let y = CGFloat(vertex.y) * nodeSize.height
        return CGPoint(x: x, y: y)
    }
    
    func vertexOrigin(vertex: Vertex, relativeToPoint point: Point) -> CGPoint {
        let vertexOrigin = self.vertexOrigin(vertex)
        let pointOrigin = self.pointOrigin(point)
        
        let relativeX = vertexOrigin.x - pointOrigin.x
        let relativeY = vertexOrigin.y - pointOrigin.y
        
        return CGPoint(x: relativeX, y: relativeY)
    }
}
