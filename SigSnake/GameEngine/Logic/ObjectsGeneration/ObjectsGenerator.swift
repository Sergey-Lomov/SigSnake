//
//  ObjectsGenerator.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/11/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

typealias GenerationResult = (objects: [GameObject], sequences:[ObjectsSequence])

protocol ObjectsGeneratorDataSource {
    func availablePoints () -> Set<Point>
}

protocol ObjectsGenerator : PauseManagerWrapper, GeneratorNodeDataSource {
    var dataSource: ObjectsGeneratorDataSource? {get set}
    
    func generate () -> GenerationResult
   
    func addNode(_ node:ObjectsGeneratorNode)
    func nodeForKey(_ key:String) -> ObjectsGeneratorNode?
}

class DefaultObjectsGenerator : ObjectsGenerator {
    
    var pauseManager = ReasonsManager<String>()
    
    var dataSource: ObjectsGeneratorDataSource?
    private var nodes = [ObjectsGeneratorNode]()
    private var availablePoints = [Point]() //Chache for available points
    
    func generate() -> GenerationResult {
        let empty = (objects: [GameObject](), sequences:[ObjectsSequence]())
        if pauseManager.isActive {return empty}
        
        guard let availablePoints = dataSource?.availablePoints() else {return empty}
        self.availablePoints = Array(availablePoints)
        
        var objects = [GameObject]()
        var sequences = [ObjectsSequence]()
        
        for node in nodes {
            let nodeResult = generateNode(node)
            objects.append(contentsOf: nodeResult.objects)
            sequences.append(contentsOf: nodeResult.sequences)
        }
        
        return (objects, sequences)
    }
    
    private func generateNode(_ node:ObjectsGeneratorNode) -> GenerationResult {
        var objects = [GameObject]()
        var sequences = [ObjectsSequence]()
        
        if Bool.random(chance: node.chance)
            && availablePoints.count > 0 {
            
            let values = node.initialiser(self)
            for value in values {
                if let object = value as? GameObject {
                    objects.append(object)
                }
                if let sequence = value as? ObjectsSequence {
                    sequences.append(sequence)
                }
            }
        }
        
        return (objects:objects, sequences:sequences)
    }
    
    func addNode(_ node: ObjectsGeneratorNode) {
        nodes.append(node)
    }
    
    func nodeForKey(_ key: String) -> ObjectsGeneratorNode? {
        let fileteredNodes = nodes.filter{return $0.key == key}
        return fileteredNodes.first
    }
    
    // MARK: Node data source
    func randomPoint() -> Point? {
        return availablePoints.randomObject()
    }
    
    func pointWasUsed(_ point: Point) {
        availablePoints.remove(object: point)
    }
    
    func pointsWasUsed(_ points: [Point]) {
        availablePoints.remove(contentsOf: points)
    }
}
