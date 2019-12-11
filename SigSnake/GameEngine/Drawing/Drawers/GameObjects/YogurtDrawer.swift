//
//  YogurtDrawer.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/17/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

class YogurtDrawer : TemporalObjectDrawer {
    private let fermentingAnimationKey = "fermenting"
    
    required init?(entity: Any, colorMap: ColorMap, mapper:GeometryMapper) {
        guard let object = entity as? Yogurt else {return nil}
        
        super.init(entity: entity, colorMap: colorMap, mapper: mapper)
        
        let animation = ObjectAnimationFactory().backgroundColorAnimation(
            duration: object.timeLimit,
            fromColor: colorMap.yogurtColor,
            toColor: colorMap.fermentedYogurtColor)
        layer.add(animation, forKey: fermentingAnimationKey)
    }
}
