//
//  HexagonFieldDrawer.swift
//  SigSnake
//
//  Created by Sergey Lomov on 6/21/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation
import UIKit

// TODO: Investigate possbility to use same drawer for hexagon and sqaure fields
class HexagonFieldDrawer : Drawer {
    required init?(entity: Any, colorMap: ColorMap, mapper:GeometryMapper) {
        if !(entity is HexagonField) {return nil}
        
        super.init(entity: entity, colorMap: colorMap, mapper: mapper)
        
        layer.frame.size = mapper.fieldSize()
        drawField()
    }
    
    private func drawField () {
        guard let field = entity as? HexagonField else {return}
        
        for point in field.points {
            if let tile = mapper.layer(forPoint: point) as? CAShapeLayer {
                tile.strokeColor = colorMap.outfieldColor.cgColor
                tile.fillColor = colorMap.fieldColor.cgColor
                layer.addSublayer(tile)
            }
            
//            let tile = mapper.layer(forPoint: point)
//            tile.backgroundColor = colorMap.fieldColor.cgColor
//            layer.addSublayer(tile)
            
        }
    }
}
