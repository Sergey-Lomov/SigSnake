//
//  CorpseDrawer.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/19/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation
import UIKit

class CorpseDrawer : TemporalObjectDrawer {
    private let animationKey = "blackout"
    
    required init?(entity: Any, colorMap: ColorMap, mapper:GeometryMapper) {
        guard let object = entity as? CorpseSegment else {return nil}
        super.init(entity: entity, colorMap: colorMap, mapper: mapper)
        hidingDuration = Constants.hidingDuration
        
        let bodyColor = colorMap.snakeBodyColor
        let corpseColor = bodyColor.colorWith(noAlphaMultiplier: Constants.colorMultiplier)
        
        let duration = object.timeLimit / 2
        let animation = ObjectAnimationFactory().backgroundColorAnimation(
            duration: duration,
            fromColor: bodyColor,
            toColor: corpseColor)
        
        layer.add(animation, forKey: animationKey)
    }
    
    // MARK: Constants
    private struct Constants {
        static let colorMultiplier:CGFloat = 0.5
        static let hidingDuration:TimeInterval = 6
    }
}
