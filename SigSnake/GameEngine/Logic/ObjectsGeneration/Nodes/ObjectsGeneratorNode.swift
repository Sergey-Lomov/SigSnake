//
//  ObjectsGeneratorNode.swift
//  SigSnake
//
//  Created by Sergey Lomov on 6/18/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

typealias GeneratorNodeInitiliser = (GeneratorNodeDataSource) -> [Any]

protocol GeneratorNodeDataSource {
    func randomPoint () -> Point?
    func pointWasUsed(_ point:Point)
    func pointsWasUsed(_ points:[Point])
}

class ObjectsGeneratorNode {
    var chance:Float
    var initialiser:GeneratorNodeInitiliser
    var key:String?
    
    var enabled:Bool = true
    
    init(chance:Float, initialiser:@escaping GeneratorNodeInitiliser) {
        self.chance = chance
        self.initialiser = initialiser
    }
}

class StandardGeneratorNode<T: PointInitialisable> : ObjectsGeneratorNode {
    init(chance:Float) {
        let initialiser:GeneratorNodeInitiliser = { dataSource in
            if let point = dataSource.randomPoint() {
                let newObject = T(point: point)
                dataSource.pointWasUsed(point)
                return [newObject]
            }
            return []
        }
        
        super.init(chance: chance, initialiser: initialiser)
    }
}
