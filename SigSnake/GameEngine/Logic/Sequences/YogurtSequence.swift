//
//  YogurtSequence.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/17/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

class YogurtSequence : ObjectsSequence, PointInitialisable {
    required init(point:Point) {
        let yogurt = Yogurt(point: point)
        let yogurtNode = ObjectsSequenceNode(object: yogurt,
                                             timer: yogurt.lifeTimer)
        
        let fermentedYogurt = FermentedYogurt(point: point)
        let fermentedYogurtNode = ObjectsSequenceNode(object: fermentedYogurt,
                                                      timer: fermentedYogurt.lifeTimer)
        
        super.init(nodes: [yogurtNode, fermentedYogurtNode])
    }
}
