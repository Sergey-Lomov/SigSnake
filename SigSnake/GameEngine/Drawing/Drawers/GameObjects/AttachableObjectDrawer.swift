//
//  AttachableObjectDrawer.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/11/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation
import UIKit

class AttachableObjectDrawer : TemporalObjectDrawer {
    var attachableWrapperLayer:CALayer
    override var topLayer: CALayer {return attachableWrapperLayer}
    
    var mainHidingDuration:TimeInterval = 0
    var attachedHidingDuration:TimeInterval = 0
    var attachScale = Constants.attachScale
    
    var inFieldZGroup = GameObjectDrawersZGroup.inField
    var attachedZGroup = GameObjectDrawersZGroup.attached
    
    required init?(entity: Any, colorMap: ColorMap, mapper:GeometryMapper) {
        attachableWrapperLayer = CALayer()
        
        super.init(entity: entity, colorMap: colorMap, mapper: mapper)
        
        attachableWrapperLayer.frame = super.topLayer.frame
        super.topLayer.frame.origin = CGPoint.zero
        attachableWrapperLayer.addSublayer(super.topLayer)
        
        update()
    }
    
    override func update() {
        super.update()
        
        guard let object = entity as? AttachableObject else {return}
        
        if object.isAttached {
            hidingDuration = attachedHidingDuration
            let transform = CATransform3DMakeScale(attachScale, attachScale, 1)
            attachableWrapperLayer.transform = transform
            topLayer.zPosition = attachedZGroup.rawValue
            disableDeviders()
        } else {
            hidingDuration = mainHidingDuration
            attachableWrapperLayer.transform = CATransform3DMakeScale(1, 1, 1)
            topLayer.zPosition = inFieldZGroup.rawValue
            enableDeviders()
        }
    }
    
    // MARK: Contants
    struct Constants {
        static let attachScale:CGFloat = 0.7
    }
}
