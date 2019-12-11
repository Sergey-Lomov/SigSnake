//
//  LightingMixer.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/23/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

// Calculates lighting for a point based on all influencing sources
protocol LightingMixer {
    func lightingFor(affects:[LightingDescription]) -> LightingDescription
}

class MaxPowerAverageColorMixer : LightingMixer {
    func lightingFor(affects: [LightingDescription]) -> LightingDescription {
        
        let totalPower = affects.map{$0.power}.reduce(0, +)
        var totalColor = LightingColor.clear
        for affect in affects {
            let poweredColor = affect.color * affect.power
            totalColor = totalColor + poweredColor
        }
        
        let color = totalColor / totalPower
        let power = affects.maxPower()
        
        return LightingDescription(color: color,
                                   power: power)
    }
}
