//
//  Geometry.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/24/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

// TODO: All geometries stacks based on two dimensions should have one general geometry stack!

// Provide calculations related to points and directions
protocol Geometry {
    func point(fromPoint point:Point,
               withDirection direction:Direction,
               inField field:Field) -> Point?
    
    func circlePoints(center:Point, radius:Int, inField field:Field) -> [Point]
    
//    func availableDirections(inPoint point:Point, inField field:Field) -> [Direction]
    func points(forVertex vertex:Vertex, inField field:Field) -> [Point]
    func vertices(forPoint point:Point, inField field:Field) -> [Vertex]
}

// Describe relations between points
protocol Direction {
    // Be careful - in some geometries opposite direction is not strictly opposite. Point uses for no solid geometries (like graph).
    func opositeInPoint(_ point:Point) -> Direction
    func isEqual(_ direction:Direction) -> Bool
}

// Describe available points
protocol Field {
    var points:Set<Point> {get}
    
    func containsPoint(_ point: Point) -> Bool
}

// Abstract vertex
protocol Vertex {

}
