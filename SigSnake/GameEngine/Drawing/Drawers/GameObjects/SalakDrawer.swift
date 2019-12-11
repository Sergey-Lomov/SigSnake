//
//  SalakDrawer.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/10/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation
import UIKit

class SalakDrawer : TemporalObjectDrawer {
    private let pulsationAnimationKey = "pulsation"
    
    required init?(entity: Any, colorMap: ColorMap, mapper:GeometryMapper) {
        super.init(entity: entity, colorMap: colorMap, mapper: mapper)
        hidingDuration = Constants.hidingDuration
        
        setBackgroundColor(colorMap.salakColor.cgColor)
        
        let animation = ObjectAnimationFactory().pulsationAnimation(
            duration: Constants.duration,
            interval: Constants.interval,
            toScale: Constants.maxScale,
            steps: Constants.steps)
        layer.add(animation, forKey: pulsationAnimationKey)
    }
    
    // MARK: Constants
    private struct Constants {
        static let duration:TimeInterval = 1
        static let interval:TimeInterval = 0.5
        static let maxScale:CGFloat = 1.3
        static let steps:Int = 3
        static let hidingDuration:TimeInterval = 4
    }
}
