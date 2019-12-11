//
//  DrawingController.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/10/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation
import UIKit

class DrawingController {
    var canvasView:UIView
    var colorMap:ColorMap
    var geometryMapper:GeometryMapper
    var game:GameController
    
    private var lightingDrawing:LightingDrawingController?
    
    // Dictionary for pairing entities and drawers
    private var drawersTypes = Dictionary<String, Drawer.Type>()
    
    private var objectsDrawers = Dictionary<GameObject, Drawer>()
    // Uses hash value instead snake objects
    private var snakesDrawers = Dictionary<Int, Drawer>()
    private var fieldDrawer:Drawer?
    
    private let mainLayer = CALayer()
    private let objectsLayer = CALayer()
    private let lightingLayer = CALayer()

    init?(canvasView:UIView, colorMap:ColorMap, game:GameController) {
        self.canvasView = canvasView
        self.colorMap = colorMap
        self.game = game
        
        let canvasSize = canvasView.frame.size
        let _mapper = GeometryMapperFactory().mapper(forGeometry: game.geometry,
                                                     field: game.field,
                                                     canvasSize: canvasSize)
        guard let mapper = _mapper else {return nil}
        geometryMapper = mapper
        
        mainLayer.frame.size = canvasView.layer.frame.size
        objectsLayer.frame.size = mainLayer.frame.size
        objectsLayer.zPosition = 1
        mainLayer.addSublayer(objectsLayer)
        
        canvasView.layer.addSublayer(mainLayer)
        canvasView.backgroundColor = colorMap.outfieldColor
        
        if let lightController = game.lightingController {
            let lightingDrawing = LightingDrawingController(game: game,
                                                            lighting: lightController,
                                                            mapper: mapper,
                                                            colorMap: colorMap)
            canvasView.layer.addSublayer(lightingDrawing.layer)
            self.lightingDrawing = lightingDrawing
        }
    }
    
    func register(drawerType:Drawer.Type, forEntityType entityType:Any.Type) {
        drawersTypes[String(describing: entityType)] = drawerType
    }
    
    func coordForPoint(_ point: Point) -> CGPoint {
        return geometryMapper.pointCenterPosition(point)
    }
    
    func canvasCoordForPoint(_ point: Point) -> CGPoint {
        let innerPoint = coordForPoint(point)
        return objectsLayer.convert(innerPoint, to: canvasView.layer)
    }
    
    func sceneSize() -> CGSize {
        return fieldDrawer?.topLayer.frame.size ?? CGSize.zero
    }
    
    func centerInCanvas() {
        mainLayer.position = CGPoint(x: canvasView.frame.width / 2,
                                     y: canvasView.frame.height / 2)
    }
    
    // MARK: Drawing
    func redraw () {
        CATransaction.setDisableActions(true)
        
        if fieldDrawer != nil {
            fieldDrawer?.update()
        } else {
            fieldDrawer = createDrawer(for: game.field)
        }
        
        for snake in game.snakes {
            if let drawer = snakesDrawers[snake.hashValue] {
                drawer.update()
            } else {
                snakesDrawers[snake.hashValue] = createDrawer(for: snake)
            }
        }
        
        for object in game.objects {
            if let drawer = objectsDrawers[object] {
                drawer.update()
            } else {
                drawNewObject(object)
            }
        }

        CATransaction.setDisableActions(false)
    }

    func drawNewObject(_ object:GameObject) {
        if let drawer = createDrawer(for: object) {
            objectsDrawers[object] = drawer
        }
    }
    
    func hideRemovedObject(_ object:GameObject) {
        if let drawer = objectsDrawers[object] {
            drawer.topLayer.removeFromSuperlayer()
            objectsDrawers.removeValue(forKey: object)
        }
    }
    
    func hideRemovedSnake(_ snake:Snake) {
        snakesDrawers[snake.hashValue]?.layer.removeFromSuperlayer()
        snakesDrawers[snake.hashValue] = nil
    }
    
    func updateLightingTiles(_ tiles:[LightingTile]) {
        lightingDrawing?.updateLightingTiles(tiles)
    }

    func initLightingDrawers() {
        lightingDrawing?.initLightingDrawers()
    }
    
    // MARK: Private
    private func createDrawer(for entity:Any) -> Drawer? {
        let typeName = String(describing: type(of: entity))
        if let type = drawersTypes[typeName] {
            let drawer = type.init(entity: entity,
                                    colorMap: colorMap,
                                    mapper: geometryMapper)
            if let drawer = drawer {
                addDrawerToLayer(drawer)
                return drawer
            }
        } else {
            assert(false, "Drawer type for \(String(describing: type(of: entity))) unregistered")
        }
        
        return nil
    }
    
    private func addDrawerToLayer (_ drawer:Drawer) {
        let layer = drawer is GameObjectDrawer ? objectsLayer : mainLayer
        layer.addSublayer(drawer.topLayer)
    }
}
