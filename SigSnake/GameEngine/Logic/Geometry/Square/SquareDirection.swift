//
//  SquareDirection.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/24/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

class SquareDirection : Direction {
    var xDisplacement, yDisplacement: Int
    
    static var zero:SquareDirection {return SquareDirection(x:0, y:0)}
    
    static var up:SquareDirection {return SquareDirection(x:0, y:-1)}
    static var down:SquareDirection {return SquareDirection(x:0, y:1)}
    static var right:SquareDirection {return SquareDirection(x:1, y:0)}
    static var left:SquareDirection {return SquareDirection(x:-1, y:0)}
    
    init(x:Int, y:Int) {
        xDisplacement = x
        yDisplacement = y
    }
    
    func opositeInPoint(_ point: Point) -> Direction {
        return SquareDirection(x: -xDisplacement, y: -yDisplacement)
    }
    
    func isEqual(_ direction: Direction) -> Bool {
        guard let direction = direction as? SquareDirection else {return false}
        
        return self.xDisplacement == direction.xDisplacement
                && self.yDisplacement == direction.yDisplacement
    }
}
