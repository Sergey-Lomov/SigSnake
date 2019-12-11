//
//  ObjectsGeneratorFactory.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/11/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

class ObjectsGeneratorFactory {
    func defaultGenerator () -> ObjectsGenerator {
        let generator = DefaultObjectsGenerator()

        // Objects
        let salakNode = StandardGeneratorNode<Salak>(chance: Chances.salak)
        let freezerNode = StandardGeneratorNode<Freezer>(chance: Chances.freezer)
        let uraborosNode = StandardGeneratorNode<Uraboros>(chance: Chances.uraboros)
        let acceleratorNode = AcceleratorGeneratorNode(chance: Chances.accelerator)
        let medusaVirusNode = MedusaVirusGeneratorNode(chance:Chances.medusaVirus)

        // Sequences
        let parmesanNode = StandardGeneratorNode<ParmesanSequence>(chance: Chances.parmesan)
        let yogurtNode = StandardGeneratorNode<YogurtSequence>(chance:Chances.yogurt)

        // Load nodes to generator
        generator.addNode(salakNode)
        generator.addNode(freezerNode)
        generator.addNode(acceleratorNode)
        generator.addNode(uraborosNode)
        generator.addNode(parmesanNode)
        generator.addNode(yogurtNode)
        generator.addNode(medusaVirusNode)
        
        return generator
    }
    
    // MARK: Chances
    struct Chances {
        static let salak:Float = 0.03
        static let freezer:Float = 0.03
        static let accelerator:Float = 0.03
        static let parmesan:Float = 0.03
        static let yogurt:Float = 0.03
        static let uraboros:Float = 0.03
        static let medusaVirus:Float = 0.03
    }
}
