//
//  AcceleratorGeneratorNode.swift
//  SigSnake
//
//  Created by Sergey Lomov on 6/18/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

class AcceleratorGeneratorNode : ObjectsGeneratorNode {
    init(chance: Float) {
        let initialiser:GeneratorNodeInitiliser = {dataSource in
            guard let point = dataSource.randomPoint() else {return []}
            
            let randomMult = drand48() > 0.5 ? 1 : -1
            let randomPower = Float.random(min: Accelerator.minPower,
                                           max: Accelerator.maxPower)
            let coeff = 1 + Float(randomMult) * randomPower
            
            let accelerator = Accelerator(point: point, coefficient: coeff)
            dataSource.pointWasUsed(point)
            return [accelerator]
        }
        
        super.init(chance: chance, initialiser: initialiser)
    }
}
