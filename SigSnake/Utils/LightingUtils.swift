//
//  LightingUtils.swift
//  SigSnake
//
//  Created by Sergey Lomov on 6/12/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

// MARK: Lighting description utils

extension LightingDescription {
    static func gradientLighting(from:LightingDescription,
                                 to:LightingDescription,
                                 index:Float) -> LightingDescription {
        let power = (to.power - from.power) * index + from.power
        let color = (to.color - from.color) * index + from.color
        return LightingDescription(color: color, power: power)
    }
}

extension Array where Element : LightingDescription {
    func average () -> LightingDescription {
        let colors = map{$0.color}
        let color = colors.average()
        
        var sumPower:Float = 0
        for lighting in self {
            sumPower += lighting.power
        }
        
        let power = sumPower / Float(count)
        return LightingDescription(color: color, power: power)
    }
    
    func maxPower () -> Float {
        return map{$0.power}.max() ?? 0
    }
}

// MARK: Lighting color utils

extension LightingColor {
    func copyWithAlphaMultiplier(_ multiplier:Float) -> LightingColor {
        let newA = a * multiplier
        return LightingColor(r: r, g: g, b: b, a: newA)
    }
    
    static func + (lhs: LightingColor, rhs:LightingColor) -> LightingColor {
        return LightingColor(r: lhs.r + rhs.r,
                             g: lhs.g + rhs.g,
                             b: lhs.b + rhs.b,
                             a: lhs.a + rhs.a)
    }
    
    static func - (lhs: LightingColor, rhs:LightingColor) -> LightingColor {
        return LightingColor(r: lhs.r - rhs.r,
                             g: lhs.g - rhs.g,
                             b: lhs.b - rhs.b,
                             a: lhs.a - rhs.a)
    }
    
    static func * (lhs: LightingColor, multiplier: Float) -> LightingColor {
        var components = [Float]()
        for component in lhs.components {
            components.append(component * multiplier)
        }
        return LightingColor(components: components)
    }
    
    static func / (lhs: LightingColor, devider: Float) -> LightingColor {
        var components = [Float]()
        for component in lhs.components {
            components.append(component / devider)
        }
        return LightingColor(components: components)
    }
}

extension Array where Element : LightingColor {
    func average() -> LightingColor {
        guard let firstColor = first else {return .clear}
        
        var components = [Float]()
        let componentsCount = firstColor.components.count
        for i in 0...componentsCount - 1 {
            var sum:Float = 0
            for color in self {
                sum += color.components[i]
            }
            
            let component = sum / Float(count)
            components.append(component)
        }
        
        return LightingColor(components: components)
    }
}
