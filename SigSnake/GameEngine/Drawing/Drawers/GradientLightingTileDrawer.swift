//
//  GradientLightingTileDrawer.swift
//  SigSnake
//
//  Created by Sergey Lomov on 6/13/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation
import UIKit

private typealias ColorExtractionBlock = (LightingDescription) -> LightingColor

class GradientLightingTileDrawer : LightingTileDrawer {
    
    override func initSublayers() {
        self.colorLayer = TileGradientLayer()
        self.fadingLayer = TileGradientLayer()
    }
    
    override func updateSublayers() {
        guard let tile = entity as? LightingTile,
            let dataSource = dataSource,
            let fadingLayer = fadingLayer as? TileGradientLayer,
            let colorLayer = colorLayer as? TileGradientLayer else {return}
        
        let vertices = dataSource.vertexies(forPoint: tile.point)
        
        let fadingVertices = gradientVertices(forVertices: vertices,
                                              colorBlock: { lighting in
                                                return self.fadingColor(lighting: lighting)
        })
        
        
        let colorVertices = gradientVertices(forVertices: vertices,
                                             colorBlock: { lighting in
                                                return self.color(lighting: lighting)
        })
        
        fadingLayer.vertices = fadingVertices
        fadingLayer.setNeedsDisplay()
        
        colorLayer.vertices = colorVertices
        colorLayer.setNeedsDisplay()
    }
    
    private func gradientVertices(forVertices vertices:[Vertex],
                                  colorBlock: ColorExtractionBlock) -> [GradientVertex] {
        var gradientVertices = [GradientVertex]()
        
        for vertex in vertices {
            let gradientVertex = self.gradientVertex(forVertex: vertex,
                                                     colorBlock: colorBlock)
            gradientVertices.append(gradientVertex)
        }
        
        return gradientVertices
    }
    
    private func gradientVertex(forVertex vertex:Vertex,
                                colorBlock: ColorExtractionBlock) -> GradientVertex {
        guard let tile = entity as? LightingTile,
            let dataSource = dataSource else {return .zero}
        
        let origin = dataSource.relativePosition(forVertex: vertex,
                                                 point: tile.point)
        let lighting = dataSource.lighting(forVertex: vertex)
        let vertexColor = colorBlock(lighting)
        let fadingVertex = GradientVertex(position: origin, color: vertexColor)
        return fadingVertex
    }
    
    private func fadingColor(lighting:LightingDescription) -> LightingColor {
        let power = lighting.power.normalise()
        let alpha = CGFloat(1 - power)
        let color = colorMap.darknessColor.withAlphaComponent(alpha)
        return LightingColor(uiColor: color)
    }
    
    private func color(lighting:LightingDescription) -> LightingColor {
        return lighting.color
    }
}
