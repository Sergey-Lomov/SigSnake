//
//  MedusaColonyEffect.swift
//  SigSnake
//
//  Created by Sergey Lomov on 6/19/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

// This class implement logic related to virus colony grown on field
class MedusaColonyEffect : GameEffect<MedusaVirus>, MedusaVirusGrowDataSource {
    
    var generatorNode:MedusaVirusGeneratorNode?
    
    override init(controller: GameController) {
        let nodeKey = MedusaVirusGeneratorNode.defaultKey
        let node = controller.objectsGenerator.nodeForKey(nodeKey)
        generatorNode = node as? MedusaVirusGeneratorNode
        
        super.init(controller: controller)
        
        generatorNode?.growDataSource = self
    }
    
    override func addReason(_ reason: MedusaVirus) {
        super.addReason(reason)
        updateGeneratorNode()
    }
    
    override func removeReason(_ reason: MedusaVirus) {
        super.removeReason(reason)
        updateGeneratorNode()
    }

    func growAvailablePoints() -> [Point] {
        let viruses:[MedusaVirus] = controller.objectsOfType()
        let virusesOnField = viruses.filter{return $0.snake == nil}
        let colonyPoints = virusesOnField.map{$0.point}
        let availablePoints = controller.availablePoints()
        var growPoints = [Point]()
        
        let field = controller.field
        let geometry = controller.geometry
        for point in colonyPoints {
            let nearbyPoints = geometry.circlePoints(center: point,
                                                     radius: 1,
                                                     inField: field)
            growPoints.append(contentsOf: nearbyPoints)
        }
        
        // Remove duplicates
        growPoints = Array(Set(growPoints))
        
        // Remove unavailable points
        growPoints = growPoints.filter{ point in
            return availablePoints.contains(point)
        }
        
        return growPoints
    }
    
    func colonySize() -> Int {
        let viruses:[MedusaVirus] = controller.objectsOfType()
        return viruses.count
    }
    
    private func updateGeneratorNode () {
        guard let generatorNode = generatorNode else {return}
        
        let size = colonySize()
        
        if size > 0 {
            let fullChance = generatorNode.growChanceFor(colonySize: size)
            generatorNode.chance = fullChance.normalise()
        } else {
            generatorNode.chance = generatorNode.spawnChance
        }
    }
}
