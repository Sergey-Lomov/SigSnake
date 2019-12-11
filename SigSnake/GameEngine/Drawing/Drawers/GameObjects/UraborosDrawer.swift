//
//  UraborosDrawer.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/19/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation
import UIKit

class UraborosDrawer : AttachableObjectDrawer {
    private let animationKey = "pulse"
    
    required init?(entity: Any, colorMap: ColorMap, mapper:GeometryMapper) {
        super.init(entity: entity, colorMap: colorMap, mapper: mapper)
        mainHidingDuration = Constants.mainHidingDuration
        attachedHidingDuration = Constants.attachedHidingDuration
        
        let color = colorMap.uraborosColor.cgColor
        let backColor = color.colorWith(noAlphaMultiplier: Constants.backgroundBrightness)
        setBackgroundColor(backColor)
        setupStrokeLayer()
    }
    
    private func setupStrokeLayer () {
        guard let shape = layer as? CAShapeLayer else {return}
        let strokeLayer = CAShapeLayer()
        strokeLayer.frame = CGRect(origin: CGPoint.zero, size: layer.frame.size)
        
        strokeLayer.strokeColor = colorMap.uraborosColor.cgColor
        strokeLayer.fillColor = UIColor.clear.cgColor
        strokeLayer.lineWidth = Constants.lineWidth
        strokeLayer.path = shape.path
        
        let strokeLenght = Double(mapper.layerStrokeLenght())
        strokeLayer.lineDashPattern = [NSNumber(value: strokeLenght)]
        layer.addSublayer(strokeLayer)
        
        let animation = ObjectAnimationFactory().strockeInOutAnimation(
            duration: Constants.animationDuration,
            lenght: CGFloat(strokeLenght))
        strokeLayer.add(animation, forKey: animationKey)
        
        let targetWidth = layer.frame.width - 2 * Constants.lineWidth
        let targetHeight = layer.frame.height - 2 * Constants.lineWidth
        let xScale = targetWidth / layer.frame.width
        let yScale = targetHeight / layer.frame.height
        let scale = min(xScale, yScale)
        
        let transform = CATransform3DMakeScale(scale, scale, 1)
        strokeLayer.transform = transform
    }
    
    // MARK: Constants
    struct Constants {
        static let animationDuration:TimeInterval = 2
        static let lineWidth:CGFloat = 3
        static let backgroundBrightness:CGFloat = 0.5
        
        static let mainHidingDuration:TimeInterval = 4
        static let attachedHidingDuration:TimeInterval = 5
    }
}
