//
//  VerticesGradientLayer.swift
//  SigSnake
//
//  Created by Sergey Lomov on 6/1/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation
import UIKit

class VerticesGradientLayer : CALayer {
    var vertices = [GradientVertex]()
    var blendMode:CGBlendMode = .normal
    
    override func render(in ctx: CGContext) {
        draw(in: ctx)
    }
    
    override func draw(in ctx: CGContext) {
        ctx.saveGState()

        ctx.setBlendMode(blendMode)
        for vertex in vertices {
            drawGradient(forVertex: vertex,
                         context: ctx)
        }
        
        ctx.restoreGState()
    }
    
    private func drawGradient(forVertex vertex:GradientVertex,
                              context:CGContext) {
        let point = vertex.position
        
        let color = vertex.color.cgColor
        let noAlphaColor = vertex.color.copyWithAlphaMultiplier(0).cgColor
        guard let initialComponents = color.components,
            let finalComponents = noAlphaColor.components,
            let colorSpace = color.colorSpace else {return}
        
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
        let center = CGPoint(x:bounds.midX, y:bounds.midY)
        context.drawLinearGradient(gradient,
                                   start: point,
                                   end: center,
                                   options: .init(rawValue: 0))
    }
}
