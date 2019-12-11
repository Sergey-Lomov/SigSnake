//
//  Drawer.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/10/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation
import UIKit

class Drawer {
    var entity:Any
    var colorMap:ColorMap
    var mapper:GeometryMapper
    lazy var layer:CALayer = {return createLayer()}()
    
    var topLayer:CALayer {return layer}
    
    required init?(entity:Any, colorMap:ColorMap, mapper:GeometryMapper) {
        self.entity = entity
        self.colorMap = colorMap
        self.mapper = mapper
    }
    
    func createLayer () -> CALayer {
        return CALayer()
    }

    func update() {
       // fatalError("Drawer is abstract class. Method should be overrided")
    }
}
