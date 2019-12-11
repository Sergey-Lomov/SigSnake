//
//  LightingSource.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/22/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation
import UIKit

// Containts info about light source
class LightingSource : Hashable, Equatable {
    private var id = UUID().uuidString
    var hashValue: Int {return id.hashValue}
    
    var lighting:LightingDescription
    
    init(power:Float = 0, color:LightingColor = LightingColor.clear) {
        
        self.lighting = LightingDescription(color: color, power: power)
    }
    
    static func == (lhs: LightingSource, rhs: LightingSource) -> Bool {
        return lhs.id == rhs.id
    }
}

class AmbientLightingSource : LightingSource {

}

class PointLightingSource : LightingSource {
    var point:Point
    
    init(point: Point, power: Float, color: LightingColor) {
        self.point = point
        super.init(power: power, color: color)
    }
}
