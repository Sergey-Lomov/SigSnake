//
//  LightingTileDrawer.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/24/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation
import UIKit

protocol LightingTileDrawerDataSource {
    func vertexies(forPoint point:Point) -> [Vertex]
    func lighting(forVertex vertex:Vertex) -> LightingDescription
    func relativePosition(forVertex vertex:Vertex, point:Point) -> CGPoint
}

class LightingTileDrawer : Drawer {
    var dataSource:LightingTileDrawerDataSource?
    
    var fadingLayer:CALayer?
    var colorLayer:CALayer?
    
    required init?(entity: Any, colorMap: ColorMap, mapper:GeometryMapper) {
        super.init(entity: entity, colorMap: colorMap, mapper: mapper)
        
        initSublayers()
        
        fadingLayer?.frame.size = layer.frame.size
        colorLayer?.frame.size = layer.frame.size
        
        if let fadingLayer = fadingLayer { layer.addSublayer(fadingLayer) }
        if let colorLayer = colorLayer { layer.addSublayer(colorLayer) }
        
        update()
    }
    
    override func createLayer() -> CALayer {
        guard let tile = entity as? LightingTile else {
            return super.createLayer()
        }
        
        return mapper.layer(forPoint: tile.point)
    }
    
    func initSublayers () {
        fadingLayer = CALayer()
        colorLayer = CALayer()
        
        fadingLayer?.backgroundColor = colorMap.darknessColor.cgColor
    }

    override func update() {
        guard let tile = entity as? LightingTile else {return}
        
        layer.position = mapper.pointCenterPosition(tile.point)
        updateSublayers()
    }
    
    func updateSublayers() {
        guard let tile = entity as? LightingTile else {return}
        
        fadingLayer?.opacity = 1 - tile.lighting.power.normalise()
        colorLayer?.backgroundColor = tile.lighting.color.cgColor
    }
}
