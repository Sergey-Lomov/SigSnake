//
//  ParmesanSequence.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/15/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

class ParmesanSequence : ObjectsSequence, PointInitialisable {
    required init(point:Point) {
        let parmesan = Parmesan(point: point)
        let parmesanNode = ObjectsSequenceNode(object: parmesan,
                                               timer: parmesan.lifeTimer)
        
        let parmesanWall = ParmesanWall(point: point)
        let parmesanWallNode = ObjectsSequenceNode(object: parmesanWall,
                                                   timer: RealtimeTimer.infinityTimer)
        
        super.init(nodes: [parmesanNode, parmesanWallNode])
    }
}
