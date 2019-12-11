//
//  SquarePoint.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/24/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

class SquarePoint : Point {
    var x,y: Int
    
    override var hashValue: Int {return "x:\(x),y:\(y)".hashValue}
    
    init (x:Int, y:Int) {
        self.x = x
        self.y = y
    }
    
    override func isEqual(_ point: Point) -> Bool {
        guard let squarePoint = point as? SquarePoint else {return false}
        
        return self.x == squarePoint.x && self.y == squarePoint.y
    }
}
