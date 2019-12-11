//
//  FreezerDrawer.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/11/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation
import UIKit

class FreezerDrawer : AttachableObjectDrawer {
    private let animationKey = "rotation"
    private var innerLayer:CALayer?
    private var onFieldTransform:CATransform3D?
    
    required init?(entity: Any, colorMap: ColorMap, mapper:GeometryMapper) {
        super.init(entity: entity, colorMap: colorMap, mapper: mapper)
        
        attachedHidingDuration = Constants.attachedHidingDuration
        mainHidingDuration = Constants.mainHidingDuration
        
        let color = colorMap.freezerColor.cgColor
        let backColor = color.colorWith(noAlphaMultiplier: Constants.backgroundBrightness)
        setBackgroundColor(backColor)
        setupInnerLayer ()
    }
    
    override func update() {
        super.update()
        
        guard let freezer = entity as? Freezer,
            let onFieldTransform = onFieldTransform else {return}
        
        if freezer.isAttached {
            innerLayer?.transform = CATransform3DIdentity
            setBackgroundColor(UIColor.clear.cgColor)
        } else {
            let color = colorMap.freezerColor.cgColor
            let backColor = color.colorWith(noAlphaMultiplier: Constants.backgroundBrightness)
            setBackgroundColor(backColor)
            innerLayer?.transform = onFieldTransform
        }
    }
    
    private func setupInnerLayer () {
        guard let shape = layer as? CAShapeLayer else {return}
        let innerLayer = CAShapeLayer()
        innerLayer.frame = CGRect(origin: CGPoint.zero, size: layer.frame.size)
        
        innerLayer.fillColor = colorMap.freezerColor.cgColor
        innerLayer.path = shape.path
        layer.addSublayer(innerLayer)
        
        let duration = Constants.animationDuration
        let animation = ObjectAnimationFactory().rotationAnimation(duration: duration)
        innerLayer.add(animation, forKey: animationKey)
        
        let width = Double(layer.frame.width)
        let height = Double(layer.frame.height)
        let diagonal = sqrt(pow(width, 2) + pow(height, 2))
        let xScale = width / diagonal
        let yScale = height / diagonal
        let scale = CGFloat(min(xScale, yScale))
        
        let onFieldTransform = CATransform3DMakeScale(scale, scale, 1)
        innerLayer.transform = onFieldTransform
        
        self.innerLayer = innerLayer
        self.onFieldTransform = onFieldTransform
    }
    
    // MARK: Constants
    struct Constants {
        static let animationDuration:TimeInterval = 1.8
        static let backgroundBrightness:CGFloat = 1.5
        static let mainHidingDuration:TimeInterval = 4
        static let attachedHidingDuration:TimeInterval = 3
    }
}
