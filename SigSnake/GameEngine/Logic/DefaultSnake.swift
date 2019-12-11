//
//  DefaultSnake.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/19/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

class DefaultSnake : Snake {
    private let id = UUID().uuidString
    
    private var geometry:Geometry {return controller.geometry}
    private var field:Field {return controller.field}
    
    var eventMutators = [GameEventMutator]()
    var isAlive: Bool = true
    var controller:GameController
    var head: SnakeHead
    var body: Array<SnakeBody> {
        didSet {
            tail = body.last ?? head
        }
    }
    var tail: SnakeSegment
    
    var hashValue: Int {return id.hashValue}
    var defaultCorpseConverter: CorpseConverterBlock
    var corpseConverter: CorpseConverterBlock
    
    private var prolongation:Int = 0
    
    required init(controller:GameController,
                  head:SnakeHead,
                  body:Array<SnakeBody>) {
        self.controller = controller
        self.head = head
        self.body = body
        self.tail = body.last ?? head
        self.defaultCorpseConverter = { segment in
            return CorpseSegment(point: segment.point)
        }
        self.corpseConverter = defaultCorpseConverter
        
        head.snake = self
        
        // Link body segments
        var previous:SnakeSegment? = head
        for bodySegment in body {
            bodySegment.snake = self
            bodySegment.previous = previous
            previous?.next = bodySegment
            previous = bodySegment
        }
        
    }
    
    func isEqual(_ snake: Snake) -> Bool {
        guard let defaultSnake = snake as? DefaultSnake else {return false}
        return id == defaultSnake.id
    }
    
    func addEventMutator(_ mutator: GameEventMutator) {
        eventMutators.append(mutator)
    }
    
    // MARK: Resizing
    
    func addProlongation(_ value: Int) {
        prolongation += value
    }
    
    func stopProlongation() {
        prolongation = 0
    }
    
    func haveProlongation() -> Bool {
        return prolongation != 0
    }
    
    func cutSnake(atSegment segment: SnakeSegment) {
        if segment == head || segment == head.previous {
            let dieEvent = DieSnakeEvent(controller: controller,
                                         snake: self,
                                         messageKey: Constants.headCuttedMessageKey)
            controller.handleEvent(dieEvent)
            return
        }
        
        guard let cutSegment = segment as? SnakeBody else {return}
        
        let parts = body.split(separator: cutSegment)
        if let aliveBodySlice = parts.first {
            self.body = Array(aliveBodySlice)
            body.last?.next = nil
        }
        
        for object in cutSegment.attachedObjects.values {
            controller.removeObject(object)
        }
        
        if parts.count > 1, let dieBodySlice = parts.last {
            let dieBody = Array(dieBodySlice)
            dieBody.forEach {handleSegmentDeath($0)}
        }
    }
    
    // MARK: Moving and points
    
    func nextPoint() -> Point? {
        let point = geometry.point(fromPoint: head.point,
                                   withDirection: head.direction,
                                   inField: controller.field)
        return point
    }
    
    func move() {
        guard let nextPoint = nextPoint() else {return}
        
        if prolongation > 0 {
            insertSegmentAfterHead()
            prolongation -= 1
        } else {
            moveBody()
        }
        
        head.point = nextPoint
    }
    
    func segmentsAtPoint(_ point: Point) -> [SnakeSegment] {
        return fullBody().filter({ segment in
            return segment.point == point
        })
    }
    
    func coveredPoints() -> [Point] {
        return fullBody().map{$0.point}
    }
    
    //MARK: Attached objects
    
    func attachObject(_ object:AttachableObject) -> SnakeSegment? {
        var attachSegment:SnakeSegment?
        
        let reversed = object.direction == .fromTailToHead
        let segments = reversed ? body.reversed() : body
        segments.forEach { segment in
            if segment.attachedObjects[object.group] == nil
            && attachSegment == nil {
                segment.attachedObjects[object.group] = object
                attachSegment = segment
            }
        }
        
        return attachSegment
    }
    
    func unattachObject(_ object: AttachableObject) {
        fullBody().forEach { segment in
            if segment.attachedObjects[object.group] == object {
                segment.attachedObjects[object.group] = nil
                object.unattach()
            }
        }
    }
    
    // MARK: Events handling
    func handleEvent(_ event: SnakeEvent) {
        let mutatedEvent = mutateEvent(event)
        if mutatedEvent.isEnable {
            if let mutatedSnakeEvent = mutatedEvent as? SnakeEvent {
                executeEvent(mutatedSnakeEvent)
            } else {
                controller.handleEvent(mutatedEvent)
            }
        }
    }
    
    private func executeEvent(_ event:SnakeEvent) {
        if let changeDirectionEvent = event as? ChangeSnakeDirectionEvent {
            changeDirection(changeDirectionEvent.direction)
        }
        
        if let cutEvent = event as? CutSnakeEvent {
            let segment = cutEvent.segment
            segment.snake?.cutSnake(atSegment: segment)
        }
        
        if let collisionEvent = event as? CollisionSnakeEvent {
            let dieEvent = DieSnakeEvent(fromCollision: collisionEvent)
            collisionEvent.controller.handleEvent(dieEvent)
        }
        
        if let outOfFieldEvent = event as? OutOfFieldSnakeEvent {
            let dieEvent = DieSnakeEvent(fromOutOfField: outOfFieldEvent)
            outOfFieldEvent.controller.handleEvent(dieEvent)
        }
        
        if let dieEvent = event as? DieSnakeEvent {
            die(controller: dieEvent.controller, messageKey: dieEvent.messageKey)
        }
    }
    
    // MARK: Private
    private func changeDirection(_ direction: Direction) {
        if let pointAtDirection = geometry.point(fromPoint: head.point,
                                                 withDirection: direction,
                                                 inField: field),
            let firstBodyPoint = head.next?.point {
            if pointAtDirection != firstBodyPoint {
                head.direction = direction
            }
        }
    }
    
    private func die(controller:GameController, messageKey:String) {
        self.isAlive = false
        fullBody().forEach {handleSegmentDeath($0)}
        controller.snakeDie(snake:self, withMessageKey: messageKey)
    }
    
    private func insertSegmentAfterHead () {
        let newBodySegment = SnakeBody(point: head.point, snake:self)
        newBodySegment.next = body.first
        body.first?.previous = newBodySegment
        head.next = newBodySegment
        newBodySegment.previous = head
        
        body.insert(newBodySegment, at: 0)
        newBodySegment.hasBeenAdded(controller)
    }
    
    private func moveBody() {
        body.reversed().forEach { segment in
            if let previousPoint = segment.previous?.point {
                segment.point = previousPoint
            }
        }
    }
    
    private func fullBody() -> [SnakeSegment] {
        var result:[SnakeSegment] = [head]
        result.append(contentsOf: body)
        return result
    }
    
    private func handleSegmentDeath(_ segment:SnakeSegment) {
        let corpseSegmet = corpseConverter(segment)
        controller.addObject(corpseSegmet)
        
        for object in segment.attachedObjects.values {
            controller.removeObject(object)
        }
    }
    
    // MARK: Constants
    struct Constants {
        static let headCuttedMessageKey = "headCutted"
    }
}
