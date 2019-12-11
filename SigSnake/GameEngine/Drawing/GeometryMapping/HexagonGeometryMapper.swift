//
//  HexagonGeometryMapper.swift
//  SigSnake
//
//  Created by Sergey Lomov on 6/21/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation
import UIKit

class HexagonGeometryMapper : GeometryMapper {
    var geometry: Geometry {return HexagonGeometry()}
    
    fileprivate var nodeRadius:CGFloat = 0
    fileprivate var field:HexagonField
    fileprivate var fieldSizeCache:CGSize?
    
    let sin60:CGFloat = CGFloat(sin(Double(60).degreesToRadians))
    
    required init?(field:Field, canvasSize:CGSize) {
        guard let hexField = field as? HexagonField else {return nil}
        self.field = hexField
        
        let widthDevider = self.widthDevider()
        let heightDevider = self.heightDevider()
        let widthRadius = canvasSize.width / widthDevider
        let heightRadius = canvasSize.height / heightDevider

        nodeRadius = min(widthRadius, heightRadius)
    }
    
    func fieldSize() -> CGSize {
        if let fieldSize = fieldSizeCache {
            return fieldSize
        }
        
        let size = CGSize(width: fieldWith(), height: fieldHeight())
        fieldSizeCache = size
        
        return size
    }
    
    func layer(forPoint point:Point) -> CALayer {
        let layer = CAShapeLayer()
        
        layer.frame.size = CGSize(width: nodeRadius * 2, height: nodeRadius * 2)
        layer.position = pointCenterPosition(point)
        layer.path = layerPath(inRect: layer.frame).cgPath
        
        return layer
    }
    
    func layerStrokeLenght() -> CGFloat {
        return nodeRadius * 6
    }
    
    func pointCenterPosition(_ point:Point) -> CGPoint {
        let origin = pointOrigin(point)
        
        let centerX = origin.x + nodeRadius
        let centerY = origin.y + nodeRadius
        
        return CGPoint(x: centerX, y: centerY)
    }
    
    func pointOrigin(_ point: Point) -> CGPoint {
        guard let hexPoint = point as? HexagonPoint else {return CGPoint.zero}

        let localX = originXForPoint(hexPoint)
        let localY = originYForPoint(hexPoint)
        let originX = localX + fieldSize().width / 2
        let originY = localY + fieldSize().height / 2
        
        return CGPoint(x: originX, y: originY)
    }
    
    func vertexOrigin(_ vertex: Vertex) -> CGPoint {
        return CGPoint.zero
    }
    
    func vertexOrigin(vertex: Vertex, relativeToPoint point: Point) -> CGPoint {
        return CGPoint.zero
    }
    
    //MARK: Maethods for overriding in derived classes
    func layerPath(inRect rect: CGRect) -> UIBezierPath {
        fatalError("Point is abstract class. Method should be overrided")
    }
    
    func widthDevider() -> CGFloat {
        fatalError("Point is abstract class. Method should be overrided")
    }
    
    func heightDevider() -> CGFloat {
        fatalError("Point is abstract class. Method should be overrided")
    }
    
    func fieldWith() -> CGFloat {
        fatalError("Point is abstract class. Method should be overrided")
    }
    
    func fieldHeight() -> CGFloat {
        fatalError("Point is abstract class. Method should be overrided")
    }
    
    func originXForPoint(_ point:HexagonPoint) -> CGFloat {
        fatalError("Point is abstract class. Method should be overrided")
    }
    
    func originYForPoint(_ point:HexagonPoint) -> CGFloat {
        fatalError("Point is abstract class. Method should be overrided")
    }
}

class FlatHexagonGeometryMapper : HexagonGeometryMapper {
    override func layerPath(inRect rect: CGRect) -> UIBezierPath {
        return UIBezierPath.hexagonFlatPath(inRect: rect)
    }
    
    override func widthDevider() -> CGFloat {
        return 1.5 * CGFloat(field.diameter) + 0.5
    }
    
    override func heightDevider() -> CGFloat {
        return sin60 * 2 * CGFloat(field.diameter)
    }
    
    override func fieldWith() -> CGFloat {
        return nodeRadius * (CGFloat(field.diameter) * 1.5 + 0.5)
    }
    
    override func fieldHeight() -> CGFloat {
        let nodeHeight = nodeRadius * 2 * sin60
        return nodeHeight * CGFloat(field.diameter)
    }
    
    override func originXForPoint(_ point: HexagonPoint) -> CGFloat {
        return 1.5 * nodeRadius * CGFloat(point.q)
    }
    
    override func originYForPoint(_ point: HexagonPoint) -> CGFloat {
        return nodeRadius * sin60 * CGFloat(point.r * 2 + point.q)
    }
}

class PointyHexagonGeometryMapper : HexagonGeometryMapper {
    override func layerPath(inRect rect: CGRect) -> UIBezierPath {
        return UIBezierPath.hexagonPointyPath(inRect: rect)
    }
    
    override func widthDevider() -> CGFloat {
        return sin60 * 2 * CGFloat(field.diameter)
    }
    
    override func heightDevider() -> CGFloat {
        return 1.5 * CGFloat(field.diameter) + 0.5
    }
    
    override func fieldWith() -> CGFloat {
        let nodeWidth = nodeRadius * 2 * sin60
        return nodeWidth * CGFloat(field.diameter)
    }
    
    override func fieldHeight() -> CGFloat {
        return nodeRadius * (CGFloat(field.diameter) * 1.5 + 0.5)
    }
    
    override func originXForPoint(_ point: HexagonPoint) -> CGFloat {
        return nodeRadius * sin60 * CGFloat(point.q * 2 + point.r)
    }
    
    override func originYForPoint(_ point: HexagonPoint) -> CGFloat {
        return 1.5 * nodeRadius * CGFloat(point.r)
    }
}
