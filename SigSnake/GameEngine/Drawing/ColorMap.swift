//
//  ColorMap.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/10/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation
import UIKit

struct ColorMap {
    var fieldColor:UIColor
    var outfieldColor:UIColor
    var darknessColor:UIColor
    var snakeBodyColor:UIColor
    var snakeHeadColor:UIColor
    
    var salakColor:UIColor
    var wallColor:UIColor
    var freezerColor:UIColor
    var minAccelerationColor:UIColor
    var maxAccelerationColor:UIColor
    var parmesanColor:UIColor
    var parmesanWallColor:UIColor
    var yogurtColor:UIColor
    var fermentedYogurtColor:UIColor
    var yogurtBacteriumColor:UIColor
    var uraborosColor:UIColor
    var medusaVirusColor:UIColor
}

class ColorMapFactory {
    func defaultMap() -> ColorMap {
        return ColorMap(
            fieldColor: Constants.defaultMap.fieldColor,
            outfieldColor: Constants.defaultMap.outfieldColor,
            darknessColor: Constants.defaultMap.darknessColor,
            snakeBodyColor: Constants.defaultMap.snakeBodyColor,
            snakeHeadColor: Constants.defaultMap.snakeHeadColor,
            salakColor: Constants.defaultMap.salakColor,
            wallColor: Constants.defaultMap.wallColor,
            freezerColor: Constants.defaultMap.freezerColor,
            minAccelerationColor: Constants.defaultMap.minAccelerationColor,
            maxAccelerationColor: Constants.defaultMap.maxAccelerationColor,
            parmesanColor: Constants.defaultMap.parmesanColor,
            parmesanWallColor: Constants.defaultMap.parmesanWallColor,
            yogurtColor: Constants.defaultMap.yogurtColor,
            fermentedYogurtColor: Constants.defaultMap.fermentedYogurtColor,
            yogurtBacteriumColor: Constants.defaultMap.yogurtBacteriumColor,
            uraborosColor: Constants.defaultMap.uraborosColor,
            medusaVirusColor: Constants.defaultMap.medusaVirusColor)
    }
    
    private struct Constants {
        struct defaultMap {
            static let fieldColor = UIColor(hex: 0xF0F0F0)
            static let outfieldColor = UIColor(hex: 0x000000)
            static let darknessColor = UIColor(hex: 0x000000)
            static let snakeBodyColor = UIColor(hex: 0xBFABE6)
            static let snakeHeadColor = UIColor(hex: 0x8C68CB)
            
            static let salakColor = UIColor(hex: 0x903000)
            static let wallColor = UIColor(hex: 0x808080)
            static let freezerColor = UIColor(hex: 0x0077B5)
            static let uraborosColor = UIColor(hex: 0xEC4339)
            
            static let minAccelerationColor = UIColor(hex: 0x3B7511)
            static let maxAccelerationColor = UIColor(hex: 0x60AA14)
            
            static let parmesanColor = UIColor(hex: 0xEFB920)
            static let parmesanWallColor = UIColor(hex: 0xAA7D00)
            
            static let yogurtColor = UIColor(hex: 0x9EDDDD)
            static let fermentedYogurtColor = UIColor(hex: 0x008891)
            static let yogurtBacteriumColor = UIColor(hex: 0x35BEC1)
            
            static let medusaVirusColor = UIColor(hex: 0xF59890)
        }
    }
}
