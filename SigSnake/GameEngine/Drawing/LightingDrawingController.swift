//
//  LightingDrawingController.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/29/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation
import UIKit

class LightingDrawingController : LightingTileDrawerDataSource {
    var layer = CALayer()
    
    private let game:GameController
    private let lightingController:LightingController
    private let mapper:GeometryMapper
    private let colorMap:ColorMap
    private let tileDrawerType:LightingTileDrawer.Type = LightingTileDrawer.self
    
    private var tilesDrawers = [LightingTile: Drawer]()
    
    init(game:GameController,
         lighting:LightingController,
         mapper:GeometryMapper,
         colorMap:ColorMap) {
        
        self.game = game
        self.lightingController = lighting
        self.mapper = mapper
        self.colorMap = colorMap
        
        layer.frame.size = mapper.fieldSize()
    }
    
    func updateLightingTiles(_ tiles:[LightingTile]) {
        CATransaction.setDisableActions(true)
        
        for tile in tiles {
            if let drawer = tilesDrawers[tile] {
                drawer.update()
            } else {
                addDrawerFor(tile)
            }
        }
        
        CATransaction.setDisableActions(false)
    }
    
    func initLightingDrawers() {
        let date = Date()
        
        if let lightingController = game.lightingController {
            for point in game.field.points {
                if let tile = lightingController.tileAt(point) {
                    addDrawerFor(tile)
                }
            }
        }
        
        let duration = Date().timeIntervalSince(date)
        print(String(format: "Light drawers init =: %.5f sec", duration))
    }
    
    private func addDrawerFor(_ tile:LightingTile) {
        if let drawer = tileDrawerType.init(entity: tile,
                                            colorMap: colorMap,
                                            mapper: mapper) {
            drawer.dataSource = self
            tilesDrawers[tile] = drawer
            drawer.update()
            layer.addSublayer(drawer.layer)
        }
    }
    
    // MARK: Lighting tile drawer data source
    func vertexies(forPoint point:Point) -> [Vertex] {
        return mapper.geometry.vertices(forPoint: point, inField: game.field)
    }
    
    func lighting(forVertex vertex:Vertex) -> LightingDescription {
        let points = mapper.geometry.points(forVertex: vertex, inField: game.field)
        let lightings = self.lightings(forPoints: points)
        let average = lightings.average()
        return average
    }
    
    func relativePosition(forVertex vertex: Vertex, point: Point) -> CGPoint {
        return mapper.vertexOrigin(vertex:vertex, relativeToPoint:point)
    }
    
    private func lightings(forPoints points:[Point]) -> [LightingDescription] {
        var lightings = [LightingDescription]()
        for point in points {
            if let lighting = lightingController.tileAt(point)?.lighting {
                lightings.append(lighting)
            }
        }
        return lightings
    }
}
