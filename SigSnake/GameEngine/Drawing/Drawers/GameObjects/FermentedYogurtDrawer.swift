//
//  FermentedYogurtDrawer.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/17/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation
import UIKit

class FermentedYogurtDrawer : AttachableObjectDrawer {
    private let hidingAnimationKey = "hiding"
    private let transformAnimationKey = "transform"
    
    required init?(entity: Any, colorMap: ColorMap, mapper:GeometryMapper) {
        super.init(entity: entity, colorMap: colorMap, mapper: mapper)
        
        attachedHidingDuration = Constants.attachedHidingDuration
        mainHidingDuration = Constants.mainHidingDuration
        
        setBackgroundColor(colorMap.fermentedYogurtColor.cgColor)
        let bacteriumCount = Int.random(min: Constants.bacteriumMinCount,
                                        max: Constants.bacteriumMaxCount)
        for _ in 0..<bacteriumCount {
            addBacterium()
        }
        
        inFieldZGroup = GameObjectDrawersZGroup.inFieldHightPriority
    }

    private func addBacterium () {
        let bacteriumLayer = CALayer()
        bacteriumLayer.frame = randomBacteriumFrame()
        bacteriumLayer.backgroundColor = colorMap.yogurtBacteriumColor.cgColor
        bacteriumLayer.cornerRadius = bacteriumLayer.frame.width / 2
        
        self.layer.addSublayer(bacteriumLayer)
        restartAnimationFor(bacteriumLayer)
    }
    
    private func restartAnimationFor(_ bacteriumLayer:CALayer) {
        bacteriumLayer.removeAnimation(forKey: transformAnimationKey)
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.restartAnimationFor(bacteriumLayer)
        }
        bacteriumLayer.add(animationFor(bacteriumLayer),
                           forKey: transformAnimationKey)
        CATransaction.commit()
    }
    
    private func animationFor(_ bacteriumLayer:CALayer) -> CAAnimation {
        let newFrame = randomBacteriumFrame()
        let currentFrame = bacteriumLayer.frame
        let tx = newFrame.origin.x - currentFrame.origin.x
        let ty = newFrame.origin.y - currentFrame.origin.y
        let scale = newFrame.width / currentFrame.width
        let translatedTransform = CATransform3DTranslate(bacteriumLayer.transform, tx, ty, 0)
        let scaledTransform = CATransform3DScale(translatedTransform, scale, scale, 1)
        
        let transformAnimation = CABasicAnimation(keyPath: "transform")
        transformAnimation.fromValue = bacteriumLayer.presentation()?.transform
        transformAnimation.toValue = scaledTransform
        transformAnimation.fillMode = kCAFillModeForwards
        transformAnimation.isRemovedOnCompletion = false
        transformAnimation.duration = Constants.bacteriumAnimationDuration
        
        return transformAnimation
    }
    
    private func randomBacteriumFrame () -> CGRect {
        let nodeSize = layer.frame.size
        let size = CGFloat.random(min: Constants.bacteriumMinSize * nodeSize.width,
                                  max: Constants.bacteriumMaxSize * nodeSize.height)
        let xOutborder = Constants.bacteriumOutborder * nodeSize.width
        let yOutborder = Constants.bacteriumOutborder * nodeSize.height
        // This is x and y of the top left corner not of the center!
        let x = CGFloat.random(min: -xOutborder,
                               max: layer.frame.width - size + xOutborder)
        let y = CGFloat.random(min: -yOutborder,
                               max: layer.frame.height - size + yOutborder)
        return CGRect(x: x, y: y, width: size, height: size)
    }
    
    // MARK: Constants
    struct Constants {
        static let bacteriumAnimationDuration:TimeInterval = 0.35
        // Bacterium size relative to cell size
        static let bacteriumMaxSize:CGFloat = 0.3
        static let bacteriumMinSize:CGFloat = 0.1
        static let bacteriumOutborder:CGFloat = 0.25
        static let bacteriumMinCount:Int = 3
        static let bacteriumMaxCount:Int = 4
        
        static let mainHidingDuration:TimeInterval = 4
        static let attachedHidingDuration:TimeInterval = 3
    }
}
