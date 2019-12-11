//
//  LightingController.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/22/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

// Control all scene lighting and current mixer. It is facade pattern for all lighting system.
protocol LightingController {
    var mixer:LightingMixer {get}
    
    func addPointSource(_ source:PointLightingSource)
    func updatePointSource(_ source:PointLightingSource)
    func removePointSource(_ source:PointLightingSource)

    func addAmbientSource(_ source:AmbientLightingSource)
    func updateAmbientSource(_ source:AmbientLightingSource)
    func removeAmbientSource(_ source:AmbientLightingSource)

    func tileAt(_ point:Point) -> LightingTile?
    
    func addSkylightController(_ controller:SkylightController)
    func start()
}

class DefaultLightingController : LightingController {
    var tiles = [Point:LightingTile]()
    var mixer:LightingMixer
    var fading:Float = Constants.defaultFading
    var controller:GameController
    
    private var geometry:Geometry {return controller.geometry}
    private var field:Field {return controller.field}
    private var skylightControllers = [SkylightController]()
    
    init(controller:GameController, mixer:LightingMixer) {
        self.controller = controller
        self.mixer = mixer
        
        for point in field.points {
            tiles[point] = DefaultLightingTile(point: point)
        }
    }
    
    func tileAt(_ point: Point) -> LightingTile? {
        return tiles[point]
    }
    
    func addSkylightController(_ controller: SkylightController) {
        skylightControllers.append(controller)
    }
    
    func start() {
        for controller in skylightControllers {
            controller.start()
        }
    }
    
    // MARK : Light sources control
    func addPointSource(_ source:PointLightingSource) {
        var affectedPoints = [Point]()

        var currentRadius:Int = 0
        var currentPower = source.lighting.power
        while currentPower > 0 {
            var points = geometry.circlePoints(center: source.point,
                                               radius: currentRadius,
                                               inField: field)
            points.remove(contentsOf: affectedPoints)

            let affect = LightingDescription(color: source.lighting.color,
                                             power: currentPower)
            
            points.forEach({ point in
                tiles[point]?.updateSourceAffect(source: source,
                                                 affect: affect,
                                                 controller: self)
            })
            
            affectedPoints.append(contentsOf: points)
            currentRadius += 1
            currentPower -= fading
        }
        
        let affectedTiles = affectedPoints.compactMap({tiles[$0]})
        controller.delegate?.lightingTilesUpdated(affectedTiles)
    }
    
    func removePointSource(_ source:PointLightingSource) {
        let exactRadius = source.lighting.power / fading
        let radius = Int(ceil(exactRadius))
        let points = geometry.circlePoints(center: source.point,
                                           radius: radius,
                                           inField: field)
        for point in points {
            tiles[point]?.updateSourceAffect(source: source,
                                             affect: nil,
                                             controller: self)
        }
        
        let affectedTiles = points.compactMap({tiles[$0]})
        controller.delegate?.lightingTilesUpdated(affectedTiles)
    }
    
    func updatePointSource(_ source: PointLightingSource) {
        // NOTE: Prefrormance at this point may be improved
        removeFromAllTiles(source)
        addPointSource(source)
        
        let allTiles = Array(tiles.values)
        controller.delegate?.lightingTilesUpdated(allTiles)
    }
    
    func addAmbientSource(_ source: AmbientLightingSource) {
        updateAmbientSource(source)
    }
    
    func updateAmbientSource(_ source: AmbientLightingSource) {
        for tile in tiles.values {
            tile.updateSourceAffect(source: source,
                                    affect: source.lighting,
                                    controller: self)
        }
        
        let allTiles = Array(tiles.values)
        controller.delegate?.lightingTilesUpdated(allTiles)
    }
    
    func removeAmbientSource(_ source: AmbientLightingSource) {
        removeFromAllTiles(source)
        
        let allTiles = Array(tiles.values)
        controller.delegate?.lightingTilesUpdated(allTiles)
    }
    
    private func removeFromAllTiles(_ source:LightingSource) {
        for tile in tiles.values {
            tile.updateSourceAffect(source: source,
                                    affect: nil,
                                    controller: self)
        }
    }

    // MARK: Constants
    struct Constants {
        static let defaultFading:Float = 0.2
    }
}
