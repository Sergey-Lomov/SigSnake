//
//  UIBezierPath+LayersShapes.swift
//  SigSnake
//
//  Created by Sergey Lomov on 6/21/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation
import UIKit

extension UIBezierPath {
    
    static func hexagonFlatPath (inRect rect: CGRect) -> UIBezierPath {
        return polygonPath(inRect: rect, verticesCount: 6, rotation: 0)
    }
    
    static func hexagonPointyPath (inRect rect: CGRect) -> UIBezierPath {
        let rotation = CGFloat(30).degreesToRadians
        return polygonPath(inRect: rect, verticesCount: 6, rotation: rotation)
    }
}
