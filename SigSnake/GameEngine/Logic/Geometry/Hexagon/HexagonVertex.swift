//
//  HexagonVertex.swift
//  SigSnake
//
//  Created by Sergey Lomov on 6/21/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

class HexagonVertex : Vertex {
    var q, r:Int
    
    init(q: Int, r: Int) {
        self.q = r
        self.r = r
    }
}
