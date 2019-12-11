//
//  UIBezierPath+Polygon.swift
//  SigSnake
//
//  Created by Sergey Lomov on 6/26/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation
import UIKit

extension UIBezierPath {
    
    /// Generate regular polygon path.
    /// - Parameter inRect: CGRect whih constaint polygon
    /// - Parameter verticesCount: Number of polygon vertices
    /// - Parameter rotation: Polygon rotation in radians
    /// - Parameter drawCircle: If true described circle will be added to path
    /// - Parameter drawSides: If true polygon sides will be added to path
    /// - Parameter drawRadius: If true lines from center to vertices will be added to path
    /// - Returns: Generated path
    static func polygonPath (inRect rect: CGRect,
                             verticesCount: UInt,
                             rotation: CGFloat,
                             drawCircle: Bool,
                             drawSides: Bool,
                             drawRadius: Bool) -> UIBezierPath {
        
        let side = min(rect.size.width, rect.size.height)
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2.0)
        let radius = side / 2
        let angleStep = .pi * 2 / CGFloat(verticesCount)
        
        var vertices = [CGPoint]()
        for i in 0...verticesCount {
            let angle = rotation + CGFloat(i) * angleStep
            let vertex = polygonVertex(center: center, radius: radius, angle: angle)
            vertices.append(vertex)
        }
        
        let path = UIBezierPath()
        guard let lastVertex = vertices.last else {return path}
        path.move(to: lastVertex)
        
        for vertex in vertices {
            
            if drawSides {
                path.addLine(to: vertex)
            } else {
                path.move(to: vertex)
            }
            
            if drawRadius {
                path.move(to: center)
                path.addLine(to: vertex)
            }
        }
        
        if drawCircle {
            path.addArc(withCenter: center,
                        radius: radius,
                        startAngle: 0,
                        endAngle: .pi * 2,
                        clockwise: true)
        }
        
        return path
    }

    static func polygonPath (inRect rect: CGRect,
                             verticesCount: UInt,
                             rotation: CGFloat) -> UIBezierPath {
//        let side = min(rect.size.width, rect.size.height)
//        let center = CGPoint(x: rect.width / 2, y: rect.height / 2.0)
//        let radius = side / 2
//        let angleStep = .pi * 2 / CGFloat(verticesCount)
//
//        let path = UIBezierPath()
//        let start = polygonVertex(center: center, radius: radius, angle: rotation)
//        path.move(to: start)
//
//        for i in 1...5 {
//            let angle = rotation + CGFloat(i) * angleStep
//            let vertex = polygonVertex(center: center, radius: radius, angle: angle)
//            path.addLine(to: vertex)
//        }
//
//        path.close()
//        return path
        return polygonPath(inRect: rect,
                           verticesCount: verticesCount,
                           rotation: rotation,
                           drawCircle: false,
                           drawSides: true,
                           drawRadius: false)
    }

    static private func polygonVertex(center: CGPoint, radius: CGFloat, angle: CGFloat) -> CGPoint {
        let cornerX = center.x + radius * cos(angle)
        let cornerY = center.y + radius * sin(angle)
        return CGPoint(x: cornerX, y: cornerY)
    }
}
