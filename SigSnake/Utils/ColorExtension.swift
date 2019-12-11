//
//  Color+Brightness.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/19/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    static var rgbBlack:UIColor {
        return UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
    }
    
    convenience init(hex: Int) {
        self.init(
            red: CGFloat((hex >> 16) & 0xFF) / 255,
            green: CGFloat((hex >> 8) & 0xFF) / 255,
            blue: CGFloat(hex & 0xFF) / 255,
            alpha: 1.0
        )
    }
    
    static func color(from lc:LightingColor) -> UIColor {
        return UIColor(red: CGFloat(lc.r),
                       green: CGFloat(lc.g),
                       blue: CGFloat(lc.b),
                       alpha: CGFloat(lc.a))
    }
    
    func colorWith(noAlphaMultiplier multiplier:CGFloat) -> UIColor {
        let cgResult = cgColor.colorWith(noAlphaMultiplier: multiplier)
        return UIColor(cgColor: cgResult)
    }
    
    func gradientTo(_ color:UIColor, index:CGFloat) -> UIColor {
        guard let fromComponents = cgColor.components,
            let colorSpace = cgColor.colorSpace,
            let toComponents = color.cgColor.components else {return .clear}
        
        if fromComponents.count != toComponents.count {return .clear}
        
        var newComponents = [CGFloat]()
        for i in 0...fromComponents.count - 1 {
            let diff = toComponents[i] - fromComponents[i]
            let component = fromComponents[i] + diff * index
            newComponents.append(component)
        }
        
        if let newColor = CGColor(colorSpace: colorSpace, components: newComponents) {
            return UIColor(cgColor: newColor)
        }
        
        return .clear
    }
}

extension CGColor {
    static func color(from lc:LightingColor) -> CGColor {
        return UIColor.color(from: lc).cgColor
    }
    
    func colorWith(noAlphaMultiplier multiplier:CGFloat) -> CGColor {
        guard let components = self.components,
            let colorSpace = self.colorSpace else {return self}
        
        var resultComponents = [CGFloat]()
        // Use -2 because we should not change last component - alpha
        for i in 0...components.count - 2 {
            let newComponent = components[i] * multiplier
            resultComponents.append(newComponent)
        }
        resultComponents.append(components[components.count - 1])
        
        let result = CGColor(colorSpace: colorSpace, components: resultComponents)
        return result ?? self
    }
}

extension LightingColor {
    var cgColor:CGColor {
        return CGColor.color(from: self)
    }
    
    var uiColor:UIColor {
        return UIColor.color(from: self)
    }
    
    convenience init (cgColor color:CGColor) {
        if let components = color.components {

            let floatComponents = components.map{return Float($0)}
            if floatComponents.count == 4 {
                // RGBA
                self.init(components: floatComponents)
            } else if floatComponents.count == 2 {
                // GrayScale
                let rgbComponents = [floatComponents[0],
                                     floatComponents[0],
                                     floatComponents[0],
                                     floatComponents[1]]
                self.init(components: rgbComponents)
            } else {
                self.init()
            }
        } else {
            self.init()
        }
    }
    
    convenience init (uiColor color:UIColor) {
        self.init(cgColor: color.cgColor)
    }
}
