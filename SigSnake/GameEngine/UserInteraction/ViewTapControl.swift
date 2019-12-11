//
//  ViewTapControl.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/10/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation
import UIKit

class ViewTapControl : UserInteractionControl {
    var delegate: UserInteractionControlDelegate?
    
    var sensorView:UIView
    var center:CGPoint
    
    init(sensorView:UIView, center:CGPoint? = nil) {
        self.sensorView = sensorView
        let sensorCenter = CGPoint(x: sensorView.frame.width / 2,
                                   y: sensorView.frame.height / 2)
        self.center = center ?? sensorCenter
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        sensorView.addGestureRecognizer(tapGesture)
    }
    
    @objc func tap (sender:UITapGestureRecognizer) {
        let tapPoint = sender.location(in: sensorView)
        let localX = Double(tapPoint.x - center.x)
        // Y should be inverted
        let localY = Double(center.y - tapPoint.y)
        let radius = sqrt(pow(localX, 2) + pow(localY, 2))
        let relativeX = localX / radius
        var angle = acos(relativeX)
        angle = localY >= 0 ? angle : -angle
        
        delegate?.userDidSelectAngle(Float(angle))
    }
}
