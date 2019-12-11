//
//  Tile.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/8/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

protocol PointInitialisable : class {
    init (point:Point)
}

// This class describe game tile
class GameObject : Equatable, Hashable {
    internal let id = UUID().uuidString
    var point:Point
    var controller:GameController?
    
    var hashValue: Int {return id.hashValue}
    
    init (point:Point) {
        self.point = point
    }
    
    static func == (lhs: GameObject, rhs: GameObject) -> Bool {
        return lhs.id == rhs.id
    }
    
    func execute(bySnake snake:Snake) {
        // For overriding in dervied classes
    }
    
    func iterateStep() {
        // For overriding in dervied classes
    }
    
    func hasBeenAdded(_ controller:GameController) {
        self.controller = controller
    }
    
    func willBeRemoved () {
        // For overriding in derived classes
    }
}
