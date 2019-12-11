//
//  SquareFieldDrawer.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/10/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation
import UIKit

class SquareFieldDrawer : Drawer {
    required init?(entity: Any, colorMap: ColorMap, mapper:GeometryMapper) {
        if !(entity is SquareField) {return nil}
        
        super.init(entity: entity, colorMap: colorMap, mapper: mapper)
        
        layer.frame.size = mapper.fieldSize()
        drawField()
    }
    
    private func drawField () {
        guard let field = entity as? SquareField else {return}
        
        for point in field.points {
            let tile = mapper.layer(forPoint: point)
            tile.backgroundColor = colorMap.fieldColor.cgColor
            layer.addSublayer(tile)
            
            // TODO: This is code for draw gradient under tiles. Use or remove this code.
//            let gradient = CAGradientLayer()
//            gradient.frame.origin = CGPoint(x: tile.frame.minX,
//                                            y: tile.frame.maxY)
//            gradient.frame.size = CGSize(width: tile.frame.width,
//                                         height: tile.frame.height * 2)
//            
//            gradient.colors = [colorMap.fieldColor.cgColor,
//                               colorMap.outfieldColor.cgColor]
//            gradient.startPoint = CGPoint(x: 0.5, y: 0)
//            gradient.endPoint = CGPoint(x: 0.5, y: 1)
//            layer.addSublayer(gradient)
            
        }
    }
}
