//
//  HexagonGeometry.swift
//  SigSnake
//
//  Created by Sergey Lomov on 6/21/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

/// For hexagon geometry used axial coordinates system. Please see description here: https://www.redblobgames.com/grids/hexagons/#coordinates. Hexagon geometry is based class for FlatHexagonGeometry and PointyHexagonGeometry. This derived classes necessary for association with mappers and user interaction controls.
class HexagonGeometry : Geometry {
    func point(fromPoint point: Point,
               withDirection direction: Direction,
               inField field: Field) -> Point? {
        guard let result = self.point(fromPoint: point, withDirection: direction)
            else {return nil}
        
        if !field.containsPoint(result) {
            return nil
        }
        
        return result
    }
    
    func circlePoints(center: Point,
                      radius: Int,
                      inField field: Field) -> [Point] {
        
        guard let center = center as? HexagonPoint,
            let field = field as? HexagonField else {
                print("Try to use hexagon geometry with no hexagon point or field ")
                return []
        }
        
        var result = [Point]()
        guard let upperCorner = point(fromPoint: center, withDirection: HexagonDirection.up)
            else {return []}
        let directions:[HexagonDirection] = [.leftBottom, .down, .rightBottom, .rightTop, .up, .leftTop]
        
        var current:Point? = upperCorner
        
        for direction in directions {
            for _ in 1...radius {
                guard let _current = current else {return []}
                result.append(_current)
                current = point(fromPoint: _current,
                                withDirection: direction)
            }
        }
        
        result = result.filter{field.containsPoint($0)}
        
        return result.compactMap{$0}
    }
    
    private func point(fromPoint point: Point,
                       withDirection direction: Direction) -> Point? {
        guard let point = point as? HexagonPoint,
            let direction = direction as? HexagonDirection else {
                print("Try to use hexagon geometry with no hexagon point, direction or field ")
                return nil
        }
        
        let resultQ = point.q + direction.qDisplacement
        let resultR = point.r + direction.rDisplacement
        
        return HexagonPoint(q: resultQ, r: resultR)
    }
    
    // MARK: Vertex methods.
    // NOTE: For now this methods uses only for lighting. Lighting system disabled, methods not implemented.
    func points(forVertex vertex: Vertex, inField field: Field) -> [Point] {
        return []
    }
    
    func vertices(forPoint point: Point, inField field: Field) -> [Vertex] {
        return []
    }
}

class FlatHexagonGeometry : HexagonGeometry {}

class PointyHexagonGeometry : HexagonGeometry {}
