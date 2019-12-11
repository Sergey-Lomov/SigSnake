//
//  TileGradientLayer.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/29/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation
import UIKit

class TileGradientLayer : CALayer {
    var vertices = [GradientVertex]() {
        didSet {
            verticesLayer.vertices = vertices
            let averageColor = vertices.map{$0.color}.average()
            centralLayer.backgroundColor = averageColor.cgColor
        }
    }
    
    private let centralLayer = CALayer()
    private let verticesLayer = VerticesGradientLayer()
    private static var centerMaskImage:CGImage? = nil // Cashed for optimisation
    
    override func layoutSublayers() {
//        let date = Date()
        
        setupCentralLayer ()
        verticesLayer.blendMode = .plusLighter
        verticesLayer.frame = bounds
        
//        let setupDuration = Date().timeIntervalSince(date)
//        print(String(format: "Gradient setup =: %.5f sec", setupDuration))
    }
    
    override func draw(in ctx: CGContext) {
        ctx.saveGState()
        
        ctx.setBlendMode(.plusLighter)
        centralLayer.render(in: ctx)
        
        let date = Date()
        verticesLayer.render(in: ctx)

        let setupDuration = Date().timeIntervalSince(date)
        print(String(format: "Gradient rendering =: %.5f sec", setupDuration))
        
        ctx.restoreGState()
    }
    
    private func setupCentralLayer () {
        if TileGradientLayer.centerMaskImage == nil {
            setupMaskImage()
        }

        if let maskImage = TileGradientLayer.centerMaskImage {
            let maskLayer = CALayer()
            maskLayer.frame.size = frame.size
            maskLayer.contents = maskImage
            centralLayer.mask = maskLayer
        }

        centralLayer.frame.size = frame.size
    }
    
    private func setupMaskImage () {
        let maskVertices = maskVerticesLayer()
        guard let context = createContext() else {return}
        
        guard let verticesImage = ciImage(forLayer: maskVertices,
                                          inContext: context) else {return}
        
        guard let maskImage = invertCIImage(verticesImage) else {return}
        let cgMaskImage = CIContext().createCGImage(maskImage, from: bounds)
        
        TileGradientLayer.centerMaskImage = cgMaskImage
    }
    
    private func maskVerticesLayer () -> CALayer {
        var maskVertices = [GradientVertex]()
        vertices.forEach { vertex in
            let color = LightingColor(uiColor: .black)
            let maskVertex = GradientVertex(position: vertex.position, color:color)
            maskVertices.append(maskVertex)
        }
        
        let maskVerticesLayer = VerticesGradientLayer()
        maskVerticesLayer.vertices = maskVertices
        maskVerticesLayer.frame.size = frame.size
        maskVerticesLayer.blendMode = .plusLighter
        
        return maskVerticesLayer
    }
    
    private func createContext () -> CGContext? {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bytesPerRow = 4 * Int(frame.width)
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue
        let context = CGContext.init(data: nil,
                                  width: Int(frame.size.width),
                                  height: Int(frame.size.height),
                                  bitsPerComponent: 8,
                                  bytesPerRow: bytesPerRow,
                                  space: colorSpace,
                                  bitmapInfo: bitmapInfo)
        
        if context == nil {
            print("Error! Can't create context in fading layer setup")
        }
        
        return context
    }
    
    private func ciImage(forLayer layer:CALayer, inContext context:CGContext) -> CIImage? {
        layer.render(in: context)
        
        guard let cgImage = context.makeImage()  else {
            print("Error! Can't create image from context in fading layer setup")
            return nil
        }
        
        return CIImage(cgImage: cgImage)
    }
    
    private func invertCIImage(_ image:CIImage) -> CIImage? {
        guard let filter = CIFilter.init(name: "CIBlendWithAlphaMask") else {return nil}
        guard let darkImage = CIImage(color: UIColor.black, size: frame.size),
            let clearImage = CIImage(color: UIColor.clear, size: frame.size)
            else {return nil}
        
        filter.setValue(clearImage, forKey: kCIInputImageKey)
        filter.setValue(darkImage, forKey: kCIInputBackgroundImageKey)
        filter.setValue(image, forKey: kCIInputMaskImageKey)
        
        return filter.outputImage
    }
}
