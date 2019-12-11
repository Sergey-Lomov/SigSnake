//
//  ParmesanDrawer.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/15/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

class ParmesanDrawer : TemporalObjectDrawer {
    private let dryingAnimationKey = "drying"
    
    required init?(entity: Any, colorMap: ColorMap, mapper:GeometryMapper) {
        guard let object = entity as? Parmesan else {return nil}
        
        super.init(entity: entity, colorMap: colorMap, mapper: mapper)
        
        let animation = ObjectAnimationFactory().backgroundColorAnimation(
            duration: object.timeLimit,
            fromColor: colorMap.parmesanColor,
            toColor: colorMap.parmesanWallColor)
        layer.add(animation, forKey: dryingAnimationKey)
    }
}
