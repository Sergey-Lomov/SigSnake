//
//  SquareField.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/24/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

class SquareField : Field {
    var points = Set<Point>()
    var width, height: Int
    
    init(width: Int, height: Int) {
        self.width = width
        self.height = height
        
        for x in 0...width-1 {
            for y in 0...height-1 {
                points.insert(SquarePoint(x: x, y: y))
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
