//
//  MedusaVirusLayersFactory.swift
//  SigSnake
//
//  Created by Sergey Lomov on 6/14/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation
import UIKit

// TODO: For now it is unused class. Should be removed.
class MedusaVirusLayersFactory {
    func attachedLayer(size:CGSize, color:UIColor) -> CALayer {
        let layer = CALayer()
        layer.frame.size = size
        
        let virusCount = Int.random(min: Constants.virusMinCount,
                                    max: Constants.virusMaxCount)
        for _ in 0..<virusCount {
            addVirus(layer:layer, color:color)
        }
        
        layer.masksToBounds = false
        return layer
    }
    
    private func createContext (size:CGSize) -> CGContext? {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bytesPerRow = 4 * Int(size.width)
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue
        let context = CGContext.init(data: nil,
                                     width: Int(size.width),
                                     height: Int(size.height),
                                     bitsPerComponent: 8,
                                     bytesPerRow: bytesPerRow,
                                     space: colorSpace,
                                     bitmapInfo: bitmapInfo)
        
        if context == nil {
            print("Error! Can't create context in medusa virus layer factory")
        }
        
        return context
    }
    
    private func addVirus(layer: CALayer, color:UIColor) {
        let size = layer.frame.size
        let virusLayer = triangleLayer(size: layer.frame.size, color: color)

        let angle = CGFloat.random(min: 0, max: 2 * .pi)
        var transform = CATransform3DMakeRotation(angle, 0, 0, 1)
        
        let xScale = CGFloat.random(min: Constants.virusMinScale,
                                    max: Constants.virusMaxScale)
        let yScale = CGFloat.random(min: Constants.virusMinScale,
                                    max: Constants.virusMaxScale)
        transform = CATransform3DScale(transform, xScale, yScale, 1)
        
        virusLayer.transform = transform
        
        let xOutborder = Constants.virusOutborder * size.width
        let yOutborder = Constants.virusOutborder * size.height
        let halfLayerWidth = virusLayer.frame.width / 2
        let halfLayerHeight = virusLayer.frame.height / 2
        let minTX = -xOutborder - halfLayerWidth
        let maxTX = size.width + xOutborder + halfLayerWidth
        let minTY = -yOutborder - halfLayerHeight
        let maxTY = size.height + yOutborder + halfLayerHeight
        
        let tx = CGFloat.random(min: minTX, max: maxTX)
        let ty = CGFloat.random(min: minTY, max: maxTY)
        transform = CATransform3DTranslate(transform, tx, ty, 0)
        virusLayer.transform = transform
        
        layer.addSublayer(virusLayer)
    }
    
    func triangleLayer (size:CGSize, color:UIColor) -> CALayer {
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: size.width, y: 0))
        path.addLine(to: CGPoint(x: size.width / 2, y: size.height))
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.close()
        
        let layer = CAShapeLayer()
        layer.frame.size = size
        layer.path = path.cgPath
        layer.masksToBounds = false
        layer.fillColor = color.cgColor
        
        return layer
    }
    
    // MARK: Constants
    struct Constants {
        // Bacterium size relative to cell size
        static let virusMaxScale:CGFloat = 0.5
        static let virusMinScale:CGFloat = 0.3
        static let virusOutborder:CGFloat = 0.25
        static let virusMinCount:Int = 3
        static let virusMaxCount:Int = 4
    }
}
