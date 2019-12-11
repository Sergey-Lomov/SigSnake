//
//  HexagonField.swift
//  SigSnake
//
//  Created by Sergey Lomov on 6/21/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

class HexagonField : Field {
    var points = Set<Point>()
    var radius: Int
    var diameter: Int {return radius * 2 + 1} // Plus one - centeral hexagon
    
    init(radius: Int) {
        self.radius = radius
        
        for q in -radius...radius {
            for r in -radius...radius {
                if q + r <= radius && q + r >= -radius {
                    points.insert(HexagonPoint(q: q, r: r))
                }
            }
        }
    }
    
    func containsPoint(_ point: Point) -> Bool {
        return points.contains(point)
    }
    
    func removePoints (_ removingPoints:[Point]) {
        points = points.filter { point in
            return !removingPoints.contains(point)
        }
    }
}
