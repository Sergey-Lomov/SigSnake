//
//  Snake.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/9/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

typealias CorpseConverterBlock = (SnakeSegment) -> GameObject

protocol Snake : EventMutatorsHolder {

    var body: Array<SnakeBody> {get} // Not includes head but first segment linked to it. Includes tail.
    var head: SnakeHead {get}
    var tail: SnakeSegment {get}
    var isAlive: Bool {get set}
 
    var defaultCorpseConverter: CorpseConverterBlock {get}
    var corpseConverter: CorpseConverterBlock {get set}
    
    var hashValue:Int {get}
    func isEqual(_ snake:Snake) -> Bool
    
    init(controller:GameController, head:SnakeHead, body:Array<SnakeBody>)
    
    func addProlongation(_ value:Int)
    func stopProlongation()
    func haveProlongation() -> Bool
    func cutSnake(atSegment segment:SnakeSegment)
    
    func move()
    func nextPoint() -> Point?
    func coveredPoints() -> [Point]
    func segmentsAtPoint(_ point:Point) -> [SnakeSegment]
    
    /// Try to attach object to snake.
    /// - Parameter object: Object for attaching
    /// - Returns: If object was attached, returns related snake segment
    func attachObject(_ object:AttachableObject) -> SnakeSegment?
    func unattachObject(_ object:AttachableObject)
    
    func handleEvent(_ event:SnakeEvent)
}
