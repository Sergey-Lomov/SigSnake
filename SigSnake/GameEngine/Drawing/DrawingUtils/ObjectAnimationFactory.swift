//
//  ObjectAnimationFactory.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/13/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation
import UIKit

enum ObjectStateChangeAnimation {
    case none, byOpacity, byScale
}

enum ObjectMainAnimation {
    case none, rotation, pulse
}

class ObjectAnimationFactory {

    enum StateChangeType {
        case show, hide
    }
    
    // MARK: State changing
    func addOpacityStateChangeAnimation(duration:TimeInterval,
                                        type:StateChangeType,
                                        toLayer layer:CALayer,
                                        key: String) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "opacity")
        let currentOpacity = layer.presentation()?.opacity ?? layer.opacity
        animation.fromValue = currentOpacity
        animation.toValue = (type == .hide) ? 0 : 1
        animation.duration = duration
        animation.autoreverses = false
        
//        if type == .hide {
            animation.isRemovedOnCompletion = false
            animation.fillMode = kCAFillModeForwards
//        }
        
        layer.add(animation, forKey: key)
        return animation
    }
    
    // MARK: Life animations
    func rotationAnimation (duration:TimeInterval) -> CAAnimation {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        
        animation.fromValue = Double.pi
        animation.toValue = -Double.pi
        animation.duration = duration
        animation.autoreverses = false
        animation.repeatCount = .infinity
        
        return animation
    }
    
    func pulsationAnimation (duration:TimeInterval,
                             interval:TimeInterval,
                             toScale:CGFloat,
                             steps:Int) -> CAAnimation {
        let group = CAAnimationGroup()
        
        var animations = [CABasicAnimation]()
        for i in 1...steps {
            let animation = pulsationAnimationStep(index: i,
                                                   totalSteps: steps,
                                                   toScale: toScale,
                                                   duration: duration)
            animations.append(animation)
        }
        
        group.animations = animations
        group.repeatCount = .infinity
        group.duration = duration + interval
     
        return group
    }
    
    private func pulsationAnimationStep(index:Int,
                                        totalSteps:Int,
                                        toScale:CGFloat,
                                        duration:TimeInterval) -> CABasicAnimation {
        let relativeScale = toScale - 1
        let scalePerStep = relativeScale / CGFloat(totalSteps)
        let invertedStepIndex = CGFloat(totalSteps - index + 1)
        let scale = 1 + scalePerStep * invertedStepIndex
        
        let animation = CABasicAnimation(keyPath: "transform")
        
        animation.fromValue = CATransform3DMakeScale(1, 1, 1)
        animation.toValue = CATransform3DMakeScale(scale, scale, 1)
        animation.duration = duration / Double(totalSteps) / 2
        animation.beginTime = duration / Double(totalSteps) * Double(index - 1)
        animation.autoreverses = true
        
        return animation
    }
    
    func jumpAnimation (duration:TimeInterval,
                        interval:TimeInterval,
                        steps:Int,
                        direction:CGPoint) -> CAAnimation {
        let group = CAAnimationGroup()
        
        var animations = [CABasicAnimation]()
        for i in 1...steps {
            let animation = jumpAnimationStep(index: i,
                                              totalSteps: steps,
                                              duration: duration,
                                              direction: direction)
            animations.append(animation)
        }
        
        group.animations = animations
        group.repeatCount = .infinity
        group.duration = duration + interval
        
        return group
    }
    
    private func jumpAnimationStep(index:Int,
                                   totalSteps:Int,
                                   duration:TimeInterval,
                                   direction:CGPoint) -> CABasicAnimation {
        let reversedStepIndex = totalSteps - index + 1
        let stepMultiplier = CGFloat(reversedStepIndex) / CGFloat(totalSteps)
        let tx = direction.x * stepMultiplier
        let ty = direction.y * stepMultiplier
        
        let animation = CABasicAnimation(keyPath: "transform")
        
        animation.fromValue = CATransform3DMakeTranslation(0, 0, 0)
        animation.toValue = CATransform3DMakeTranslation(tx, ty, 0)
        animation.duration = duration / Double(totalSteps) / 2
        animation.beginTime = duration / Double(totalSteps) * Double(index - 1)
        animation.autoreverses = true
        
        return animation
    }
    
    func backgroundColorAnimation (duration:TimeInterval,
                                   fromColor:UIColor,
                                   toColor:UIColor) -> CAAnimation {
        let animation = CABasicAnimation(keyPath: "fillColor")
        
        animation.fromValue = fromColor.cgColor
        animation.toValue = toColor.cgColor
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeBoth
        
        return animation
    }
    
    // This is not the same scale animation.
    // When you use resize animation, border width and other inner elements will not be scaled.
    func resizePulsationAnimation (duration:TimeInterval,
                                   interval:TimeInterval,
                                   steps:Int,
                                   initialSize:CGSize,
                                   targetSize:CGSize) -> CAAnimation {
        let group = CAAnimationGroup()
        
        var animations = [CABasicAnimation]()
        for i in 1...steps {
            let animation = resizeAnimationStep(index: i,
                                                totalSteps: steps,
                                                duration: duration,
                                                initialSize:initialSize,
                                                targetSize:targetSize)
            animations.append(animation)
        }
        
        group.animations = animations
        group.repeatCount = .infinity
        group.duration = duration + interval
        
        return group
    }
    
    private func resizeAnimationStep(index:Int,
                                     totalSteps:Int,
                                     duration:TimeInterval,
                                     initialSize:CGSize,
                                     targetSize:CGSize) -> CABasicAnimation {
        let reversedStepIndex = totalSteps - index + 1
        let stepMultiplier = CGFloat(reversedStepIndex) / CGFloat(totalSteps)
        let widthDiff = targetSize.width - initialSize.width
        let width = initialSize.width + widthDiff * stepMultiplier
        let heightDiff = targetSize.height - initialSize.height
        let height = initialSize.height + heightDiff * stepMultiplier
        let x = (initialSize.width - width) / 2
        let y = (initialSize.height - height) / 2
        let bounds = CGRect(x: x, y: y, width: width, height: height)
        let initialBounds = CGRect(origin: CGPoint.zero, size: initialSize)
        
        let animation = CABasicAnimation(keyPath: "bounds")
        
        animation.fromValue = NSValue.init(cgRect: initialBounds)
        animation.toValue = NSValue.init(cgRect: bounds)
        animation.duration = duration / Double(totalSteps) / 2
        animation.beginTime = duration / Double(totalSteps) * Double(index - 1)
        animation.autoreverses = true
        
        return animation
    }
    
    func strockeInOutAnimation(duration:TimeInterval, lenght:CGFloat) -> CAAnimation {
        let animation = CABasicAnimation(keyPath: "lineDashPhase")
        animation.fromValue = 0
        animation.toValue = lenght * 2
        animation.duration = duration
        animation.beginTime = 0.0
        animation.repeatCount = .infinity
        
        return animation
    }
}
