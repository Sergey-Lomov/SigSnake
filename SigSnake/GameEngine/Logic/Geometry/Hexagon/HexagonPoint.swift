//
//  HexagonPoint.swift
//  SigSnake
//
//  Created by Sergey Lomov on 6/21/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

class HexagonPoint : Point {
    var q, r: Int
    
    override var hashValue: Int {return "q:\(q),r:\(r)".hashValue}
    
    init (q:Int, r:Int) {
        self.q = q
        self.r = r
    }
    
    override func isEqual(_ point: Point) -> Bool {
        guard let hexPoint = point as? HexagonPoint else {return false}
        
        return self.q == hexPoint.q && self.r == hexPoint.r
    }
}
