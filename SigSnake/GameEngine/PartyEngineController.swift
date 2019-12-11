//
//  EngineController.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/10/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation
import UIKit

protocol PartyEngineDelegate {
    func snake(_ snake:Snake, didMoveToPoint point:CGPoint)
}

// This class control interaction between game elements: drawing, logic, timing and e.t.c.
class PartyEngineController : StepsControllerDelegate, GameControllerDelegate, UserInteractorDelegate {
    
    var gameController:GameController
    var drawingController:DrawingController
    var stepsController:StepsController
    var userInteractors:[UserInteractor]
    
    var delegate:PartyEngineDelegate?
    
    init?(game:GameController, canvasView:UIView, stepsController:StepsController, userInteractors:[UserInteractor]) {
        self.gameController = game
        let _drawing = DrawingControllerFactory().drawing(forGame: game,
                                                          canvasView: canvasView)
        guard let drawing = _drawing else {return nil}
        
        self.drawingController = drawing
        self.stepsController = stepsController
        self.userInteractors = userInteractors
        
        self.stepsController.delegate = self
        self.gameController.delegate = self
        
        for interactor in userInteractors {
            interactor.delegate = self
        }
    }
    
    func start() {
        drawingController.initLightingDrawers()
        drawingController.redraw()
        stepsController.execute()
        gameController.start()
    }
    
    func stepForward() {
//        var date = Date()
        gameController.iterateStep()
//        let stepDuration = Date().timeIntervalSince(date)
//        date = Date()
        drawingController.redraw()
//        let drawDuration = Date().timeIntervalSince(date)
//
//        print(String(format: "Step handling =: %.5f sec", stepDuration))
//        print(String(format: "Step drawing =: %.5f sec", drawDuration))
        
        for snake in gameController.snakes {
            let headPoint = snake.head.point
            let position = drawingController.canvasCoordForPoint(headPoint)
            delegate?.snake(snake, didMoveToPoint: position)
        }
    }
    
    func pauseGame() {
        
    }
    
    func requestStepsAcceleration(_ acceleratoion: Float) {
        stepsController.accelerate(acceleratoion)
    }
    
    func changeSnakeDirection(snake: Snake, direction: Direction) {
        let event = ChangeSnakeDirectionEvent(controller: gameController,
                                              snake: snake,
                                              direction: direction)
        gameController.handleEvent(event)
    }
    
    // MARK: Game controller delegate
    func die(snake:Snake, withMessage message: String?) {
        drawingController.hideRemovedSnake(snake)
    }
    
    func objectWasAdded(_ object: GameObject) {
        drawingController.drawNewObject(object)
    }
    
    func objectHasBeenRemoved(_ object: GameObject) {
        drawingController.hideRemovedObject(object)
    }
    
    func lightingTilesUpdated(_ tiles: [LightingTile]) {
        drawingController.updateLightingTiles(tiles)
    }
}
