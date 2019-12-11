//
//  DefaultGameController.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/16/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

class DefaultGameController : GameController {
    var delegate:GameControllerDelegate?
    
    var field:Field
    var snakes:[Snake] = [Snake]()
    var objects = [GameObject]()
    var sequences = [ObjectsSequence]()
    var eventMutators = [GameEventMutator]()
    var objectsGenerator: ObjectsGenerator
    var geometry:Geometry
    var lightingController: LightingController?
    
    init(field:Field, objectsGenerator:ObjectsGenerator, geometry:Geometry) {
        self.field = field
        self.objectsGenerator = objectsGenerator
        self.geometry = geometry
        
        self.objectsGenerator.dataSource = self
    }
    
    func start() {
        lightingController?.start()
    }
    
    func iterateStep () {
        iterateGameElementsStep()
        
        for snake in snakes {
            interactAndMove(snake: snake)
        }
        
        generateGameElements()
    }
    
    func addSnake(_ snake: Snake) {
        snakes.append(snake)
        
        snake.head.hasBeenAdded(self)
        snake.body.forEach{$0.hasBeenAdded(self)}
    }
    
    func snakeDie(snake: Snake, withMessageKey message: String?) {
        if let snakeIndex = snakes.index(where: {$0.isEqual(snake)}) {
            snakes.remove(at: snakeIndex)
        }
        delegate?.die(snake:snake, withMessage: message)
    }

    // MARK: Objects/sequences managing
    
    func addSequence(_ sequence: ObjectsSequence) {
        sequences.append(sequence)
        sequence.start(withController: self)
    }
    
    func removeSequence(_ sequence: ObjectsSequence) {
        sequences.remove(object: sequence)
        
        if objects.contains(sequence.currentNode.object) {
            removeObject(sequence.currentNode.object)
        }
    }
    
    func addObject(_ object: GameObject) {
        objects.append(object)
        object.hasBeenAdded(self)
        delegate?.objectWasAdded(object)
    }
    
    func removeObject(_ object: GameObject) {
        for snake in snakes {
            if let attachableObject = object as? AttachableObject {
                snake.unattachObject(attachableObject)
            }
        }
        
        if let index = objects.index(of: object) {
            object.willBeRemoved()
            objects.remove(at: index)
            delegate?.objectHasBeenRemoved(object)
        }
        
        for sequence in sequences {
            sequence.handleObjectRemoving(object, controller: self)
        }
    }
    
    func objectsAtPoint(_ point: Point) -> [GameObject] {
        return objects.filter({ (object) -> Bool in
            return object.point == point
        })
    }
    
    func objectsOfType<T>() -> [T] where T : GameObject {
        return objects.filteredByType()
    }
    
    // MARK: event managing
    func addEventMutator(_ mutator: GameEventMutator) {
        eventMutators.append(mutator)
    }
    
    func handleEvent(_ event:GameEvent) {
        let mutatedEvent = mutateEvent(event)
        if mutatedEvent.isEnable {
            if let snakeEvent = mutatedEvent as? SnakeEvent {
                snakeEvent.snake.handleEvent(snakeEvent)
            } else {
                executeEvent(mutatedEvent)
            }
        }
    }
    
    func executeEvent(_ event:GameEvent) {
        // TODO: Implement objects adding and removing as events. Also implement many other events.
    }
    
    // MARK: Objects generator datasource
    func availablePoints() -> Set<Point> {
        var availablePoints = field.points
        
        for object in objects {
            availablePoints.remove(object.point)
        }
        
        for snake in snakes {
            for point in snake.coveredPoints() {
                availablePoints.remove(point)
            }
        }
        
        return availablePoints
    }
    
    // MARK: Private
    private func iterateGameElementsStep () {
        for sequence in sequences {
            sequence.update(withController: self)
        }
        
        for object in objects {
            object.iterateStep()
        }
    }
    
    private func interactAndMove(snake:Snake) {
        if let nextPoint = snake.nextPoint() {
            
            // At objects execution new objects may be produced. By this reason game controller at first collect all necessary objects and after that execute these objects.
            var objectsInPoint = objectsAtPoint(nextPoint)
            
            for currentSnake in snakes {
                let segmentsAtPoint = currentSnake.segmentsAtPoint(nextPoint)
            
                for segmentAtPoint in segmentsAtPoint {
                    objectsInPoint.append(segmentAtPoint)
                }
            }
            
            for object in objectsInPoint {
                object.execute(bySnake: snake)
            }
        } else {
            let event = OutOfFieldSnakeEvent(controller: self, snake: snake)
            handleEvent(event)
        }
        
        if snake.isAlive {
            snake.move()
        }
    }
    
    private func generateGameElements () {
        let newGameElements = objectsGenerator.generate()
        for object in newGameElements.objects {
            addObject(object)
        }
        for sequence in newGameElements.sequences {
            addSequence(sequence)
        }
    }
}
