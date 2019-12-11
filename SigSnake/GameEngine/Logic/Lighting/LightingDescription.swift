//
//  LightingDescription.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/23/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

// Contains base lighting info
class LightingDescription {
    var color:LightingColor
    var power:Float
    
    init(color:LightingColor = .clear, power:Float = 0.0) {
        self.color = color
        self.power = power
    }
    
    static var zero:LightingDescription {
        return LightingDescription()
    }
}
