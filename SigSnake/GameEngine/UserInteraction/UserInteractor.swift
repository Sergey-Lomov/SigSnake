//
//  UserInteractor.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/10/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

protocol UserInteractorDelegate {
    func changeSnakeDirection(snake:Snake, direction:Direction)
    func pauseGame()
}

protocol UserInteractionControlDelegate {
    func userDidSelectAngle(_ angle:Float)
}

protocol UserInteractionControl {
    var delegate:UserInteractionControlDelegate? {get set}
}

protocol UserInteractionGeometryTranslator {
    func directionForAngle(_ angle:Float, point:Point, field:Field) -> Direction
}

class UserInteractor : UserInteractionControlDelegate {
    var delegate:UserInteractorDelegate?
    var control:UserInteractionControl
    var translator:UserInteractionGeometryTranslator
    
    private var field:Field
    private var snake:Snake
    
    init(control:UserInteractionControl,
         translator:UserInteractionGeometryTranslator,
         field:Field, snake:Snake) {
        self.control = control
        self.translator = translator
        self.field = field
        self.snake = snake
        
        self.control.delegate = self
    }
    
    func userDidSelectAngle(_ angle: Float) {
        let direction = translator.directionForAngle(angle,
                                                     point: snake.head.point,
                                                     field: field)
        delegate?.changeSnakeDirection(snake: snake, direction: direction)
    }
}
