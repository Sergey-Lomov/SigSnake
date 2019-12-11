//
//  MedusaVirusGeneratorNode.swift
//  SigSnake
//
//  Created by Sergey Lomov on 6/18/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

protocol MedusaVirusGrowDataSource {
    func growAvailablePoints() -> [Point]
    func colonySize() -> Int
}

class MedusaVirusGeneratorNode : ObjectsGeneratorNode {
    static let defaultKey = "MedusaVirus"
    
    var growDataSource:MedusaVirusGrowDataSource?
    var spawnChance:Float
    var growRate = Constants.defaultGrowRate
    
    init(chance: Float) {
        let standardNode = StandardGeneratorNode<MedusaVirus>(chance: chance)
        let standardInitialiser = standardNode.initialiser
        spawnChance = chance
        
        super.init(chance: chance, initialiser: standardInitialiser)
        key = MedusaVirusGeneratorNode.defaultKey
        
        initialiser = { dataSource in
            if let growPoints = self.growDataSource?.growAvailablePoints(),
                growPoints.count > 0 {
                let viruses = self.growInPoints(growPoints)
                let points = viruses.map{$0.point}
                dataSource.pointsWasUsed(points)
                return viruses
            }
            
            return standardInitialiser(dataSource)
        }
    }
    
    func growChanceFor(colonySize:Int) -> Float {
        return Float(colonySize) * growRate
    }
    
    private func growInPoints(_ points:[Point]) -> [MedusaVirus] {
        guard let dataSource = growDataSource else {return []}
        
        var availablePoints = points
        var viruses = [MedusaVirus]()
        // May be more than 1 (more than 100%). In this case spawn few viruse objects.
        var currentCance = growChanceFor(colonySize: dataSource.colonySize())
    
        while currentCance > 0 && availablePoints.count > 0 {
            if Bool.random(chance: currentCance) {
                if let newVirus = growOnceInPoints(availablePoints) {
                    availablePoints.remove(object: newVirus.point)
                    viruses.append(newVirus)
                }
            }
            currentCance -= 1
        }
        
        return viruses
    }
    
    private func growOnceInPoints(_ points:[Point]) -> MedusaVirus? {
        guard let point = points.randomObject() else {return nil}
        return MedusaVirus(point: point)
    }
    
    // MARK: Constants
    struct Constants {
        static let defaultGrowRate:Float = 0.05
    }
}
