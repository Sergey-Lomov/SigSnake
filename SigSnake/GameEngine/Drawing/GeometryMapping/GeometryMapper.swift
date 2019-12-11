//
//  Coordinator.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/10/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation
import UIKit

// Geometry mapper implement transitions from Game logic geometry to UI canvas geometry
protocol GeometryMapper {
    // TODO: Investigate why we need geometry here?
    var geometry:Geometry {get}
    
    // This initaliser uses vy mappers factory
    init?(field:Field, canvasSize:CGSize)
    
    func fieldSize() -> CGSize
    func layer(forPoint point:Point) -> CALayer
    func layerStrokeLenght() -> CGFloat
    func pointCenterPosition(_ point:Point) -> CGPoint
    func pointOrigin(_ point:Point) -> CGPoint //Top left corner
//    func connectionPath(forPoint point:Point, direction:Direction) -> CGPath
    
    // MARK: Vertex uses only at lighting system (disable for now)
    func vertexOrigin(_ vertex:Vertex) -> CGPoint
    func vertexOrigin(vertex:Vertex, relativeToPoint point:Point) -> CGPoint
}
