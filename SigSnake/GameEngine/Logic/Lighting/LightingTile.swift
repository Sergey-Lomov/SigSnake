//
//  LightingTile.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/23/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation
import UIKit

// Contains info about ont tile - lighting and cash with all affects from all nearby sources
class LightingTile : Hashable, Equatable {
    private var id = UUID().uuidString
    var hashValue: Int {return id.hashValue}
    
    var point:Point
    var lighting = LightingDescription.zero
    
    init(point:Point) {
        self.point = point
    }
    
    func updateSourceAffect(source:LightingSource,
                            affect:LightingDescription?,
                            controller:LightingController) {
        fatalError("LightingTile is abstract class. MEthod should be overrided in derived class.")
    }
    
    static func == (lhs: LightingTile, rhs: LightingTile) -> Bool {
        return lhs.id == rhs.id
    }
}

class DefaultLightingTile : LightingTile {

    private var affectsSources = [LightingSource : LightingDescription]()

    override func updateSourceAffect(source:LightingSource,
                            affect:LightingDescription?,
                            controller:LightingController) {
        affectsSources[source] = affect
        let affects = affectsSources.map {$0.value}
        
        lighting = controller.mixer.lightingFor(affects: affects)
    }
}
