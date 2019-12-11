//
//  MedusaVirusDrawer.swift
//  SigSnake
//
//  Created by Sergey Lomov on 6/14/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation
import UIKit

class MedusaVirusDrawer : AttachableObjectDrawer {
    private var attachColor:UIColor?
    
    required init?(entity: Any, colorMap: ColorMap, mapper:GeometryMapper) {
        super.init(entity: entity, colorMap: colorMap, mapper: mapper)
        
        attachScale = 1.0
        attachedZGroup = GameObjectDrawersZGroup.attachedLowPriority
    }
    
    override func update() {
        super.update()
        guard let virus = entity as? MedusaVirus else {return}
        
        if virus.isAttached {
            let fromColor = colorMap.snakeBodyColor
            let toColor = colorMap.wallColor
            let index = CGFloat(virus.incubationProgress)
            let color = fromColor.gradientTo(toColor, index: index)
            setBackgroundColor(color.cgColor)
            enableDeviders()
        } else {
            setBackgroundColor(colorMap.medusaVirusColor.cgColor)
        }
    }
}
