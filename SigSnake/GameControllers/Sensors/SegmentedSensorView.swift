//
//  SegmentedSensorView.swift
//  SigSnake
//
//  Created by Sergey Lomov on 6/26/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation
import UIKit

class SegmentedSensorView : SensorView {
    var centerColor:UIColor?
    var sideColor:UIColor?
    var borderColor:UIColor?
    var segmentsCount:UInt?
    
    override func draw(_ rect: CGRect) {
        if let ctx = UIGraphicsGetCurrentContext() {
            drawRadialGradient(in: ctx)
            drawBorders(in: ctx)
        }
    }
    
    private func drawRadialGradient (in context:CGContext) {
        guard let initialComponents = centerColor?.cgColor.components,
            let finalComponents = sideColor?.cgColor.components,
            let colorSpace = centerColor?.cgColor.colorSpace else {return}
        
        var components = [CGFloat]()
        components.append(contentsOf: initialComponents)
        components.append(contentsOf: finalComponents)
        
        let locations:[CGFloat] = [0.0, 1.0]
        let count:size_t = 2
        
        let _gradient = CGGradient(colorSpace: colorSpace,
                                   colorComponents: components,
                                   locations: locations,
                                   count: count)
        
        guard let gradient = _gradient else {return}
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = max(bounds.width, bounds.height) / 2
        context.drawRadialGradient(gradient,
                                   startCenter: center,
                                   startRadius: 0,
                                   endCenter: center,
                                   endRadius: radius,
                                   options: .init(rawValue: 0))
    }
    
    private func drawBorders (in context:CGContext) {
        guard let borderColor = borderColor?.cgColor,
            let segmentsCount = segmentsCount else {return}
        
        let path = UIBezierPath.polygonPath(inRect: bounds,
                                            verticesCount: segmentsCount,
                                            rotation: 0,
                                            drawCircle: true,
                                            drawSides: false,
                                            drawRadius: true)
        path.lineWidth = Constants.lineWidth
        context.setStrokeColor(borderColor)
        context.addPath(path.cgPath)
        context.strokePath()
    }
    
    // MARK: Constants
    struct Constants {
        static let lineWidth:CGFloat = 3
    }
}
