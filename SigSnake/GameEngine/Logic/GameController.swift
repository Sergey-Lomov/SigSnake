//
//  GameController.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/8/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

protocol GameController : EventMutatorsHolder, ObjectsGeneratorDataSource {
    var delegate:GameControllerDelegate? {get set}
    
    var snakes:[Snake] {get}
    var field:Field {get}
    var objects:Array<GameObject> {get}
    var objectsGenerator:ObjectsGenerator {get}
    var geometry:Geometry {get}
    var lightingController:LightingController? {get}
    
    func start()
    
    func addSnake(_ snake:Snake)
    func snakeDie(snake:Snake, withMessageKey message:String?)
    func iterateStep()
    
    func addObject(_ object:GameObject)
    func removeObject(_ object:GameObject)
    // Move object at front of execution queue
    func objectsAtPoint(_ point:Point) -> [GameObject]
    func objectsOfType<T:GameObject>() -> [T]
    
    func addSequence(_ sequence:ObjectsSequence)
    func removeSequence(_ sequence:ObjectsSequence)
    
    func handleEvent(_ event:GameEvent)
}

protocol GameControllerDelegate {
    func die(snake:Snake, withMessage message:String?)
    
    func objectWasAdded(_ object:GameObject)
    func objectHasBeenRemoved(_ object:GameObject)
    func lightingTilesUpdated(_ tiles:[LightingTile])
    
    func requestStepsAcceleration(_ acceleratoion:Float)
}
