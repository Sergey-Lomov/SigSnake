//
//  GradientVertex.swift
//  SigSnake
//
//  Created by Sergey Lomov on 6/6/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation
import UIKit

class GradientVertex {
    var position:CGPoint
    var color:LightingColor
    
    init (position:CGPoint, color:LightingColor) {
        self.position = position
        self.color = color
    }
    
    static var zero:GradientVertex {
        return GradientVertex(position: .zero, color: .clear)
    }
}

//extension Array where Element : GradientVertex {
//    func averageAlpha () -> Float {
//        let sum = map{$0.alpha}.reduce(0, +)
//        return sum / Float(count)
//    }
//}
