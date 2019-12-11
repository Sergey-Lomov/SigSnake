//
//  HexagonDirection.swift
//  SigSnake
//
//  Created by Sergey Lomov on 6/21/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

class HexagonDirection : Direction {
    var qDisplacement, rDisplacement: Int
    
    static var zero:HexagonDirection {return HexagonDirection(q:0, r:0)}
    
    static var up:HexagonDirection {return HexagonDirection(q:0, r:-1)}
    static var down:HexagonDirection {return HexagonDirection(q:0, r:1)}
    static var rightTop:HexagonDirection {return HexagonDirection(q:1, r:-1)}
    static var rightBottom:HexagonDirection {return HexagonDirection(q:1, r:0)}
    static var leftTop:HexagonDirection {return HexagonDirection(q:-1, r:0)}
    static var leftBottom:HexagonDirection {return HexagonDirection(q:-1, r:1)}
    
    init(q:Int, r:Int) {
        qDisplacement = q
        rDisplacement = r
    }
    
    func opositeInPoint(_ point: Point) -> Direction {
        return HexagonDirection(q: -qDisplacement, r: -rDisplacement)
    }
    
    func isEqual(_ direction: Direction) -> Bool {
        guard let direction = direction as? HexagonDirection else {return false}
        
        return self.qDisplacement == direction.qDisplacement
            && self.rDisplacement == direction.rDisplacement
    }
}
