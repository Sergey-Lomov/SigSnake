//
//  Point.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/10/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

// Describe one poin in specific geometry
class Point : Equatable, Hashable {
    var hashValue: Int {
        fatalError("Point is abstract class. Method should be overrided")
    }
    
    static func == (lhs: Point, rhs: Point) -> Bool {
        return lhs.isEqual(rhs)
    }
    
    // Oprator == compares objects, idEqual compares content
    internal func isEqual(_ point: Point) -> Bool {
        fatalError("Point is abstract class. Method should be overrided")
    }
}
