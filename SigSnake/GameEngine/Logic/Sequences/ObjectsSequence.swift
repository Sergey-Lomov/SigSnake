//
//  ObjectsSequence.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/15/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

protocol ObjectsSequenceMember {
    func shouldMutate(sequence:ObjectsSequence) -> Bool
}

struct ObjectsSequenceNode {
    var object:GameObject
    var timer:GameTimer
}

class ObjectsSequence : Equatable {
    private var id = UUID().uuidString
    
    private var nodeIter:Int = 0
    var currentNode:ObjectsSequenceNode {return nodes[nodeIter]}
    var nodes:[ObjectsSequenceNode]
    var isRepeatable:Bool = false
    
    init(nodes:[ObjectsSequenceNode] = [ObjectsSequenceNode]()) {
        self.nodes = nodes
    }
    
    func start(withController controller:GameController) {
        if let firstNode = nodes.first {
            controller.addObject(firstNode.object)
            firstNode.timer.start()
        }
    }
    
    func update(withController controller:GameController) {
        if currentNode.timer.isLeft() {
            let nextIndex = nodeIter < nodes.count - 1 ? nodeIter + 1 : 0
            if nextIndex != 0 || isRepeatable {
                activateObject(index: nextIndex, controller: controller)
            }
        }
    }
    
    func pause(withKey key:String) {
        currentNode.timer.pause(withKey: key)
    }
    
    func resume(withKey key:String) {
        currentNode.timer.resume(withKey: key)
    }
    
    func handleObjectRemoving (_ object:GameObject, controller:GameController) {
        let objects = nodes.map({$0.object})
        if objects.contains(object) && object == currentNode.object {
            controller.removeSequence(self)
        }
    }
    
    static func == (lhs: ObjectsSequence, rhs: ObjectsSequence) -> Bool {
        return lhs.id == rhs.id
    }
    
    private func activateObject(index:Int, controller:GameController) {
        if nodeIter == index {return}
        
        let oldNode = currentNode
        nodeIter = index
        
        oldNode.timer.reset()
        controller.removeObject(oldNode.object)
        
        controller.addObject(currentNode.object)
        currentNode.timer.start()
    }
}
