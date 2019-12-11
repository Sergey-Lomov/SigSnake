//
//  GameViewController.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/8/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, PartyEngineDelegate {

    @IBOutlet var canvasView:UIView!
    
    private var partyEngine:PartyEngineController?
    private var sensors = [SensorView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        canvasView.isUserInteractionEnabled = true
        
        let game = GameControllerFactory().hexagonGame()
        let stepsController = StepsControllerFactory().defaultAcceleratedStepsController()
        
        setupSensors(game:game)
        let interactors = createInteractors(game: game)

        partyEngine = PartyEngineController(game: game,
                                            canvasView: canvasView,
                                            stepsController: stepsController,
                                            userInteractors: interactors)
        partyEngine?.delegate = self
        partyEngine?.start()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        partyEngine?.drawingController.centerInCanvas()
    }

    // MARK: Party engine delegate
    func snake(_ snake: Snake, didMoveToPoint point: CGPoint) {
        sensors.forEach {$0.handleSnakePosition(snake: snake, position: point, inCanvas: canvasView)}
    }
    
    // MARK: Private
    func setupSensors (game:GameController) {
        for snake in game.snakes {
            let sensor = SensorViewFactory().sensorFor(game: game,
                                                       snake: snake,
                                                       type: .movable,
                                                       canvas: canvasView)
            view.addSubview(sensor)
            sensors.append(sensor)
        }
    }
    
    private func createInteractors(game:GameController) -> [UserInteractor] {
        var interactors = [UserInteractor]()
        for sensor in sensors {
            guard let snake = sensor.snake else {continue}
            
            let control = ViewTapControl(sensorView: sensor)
            let factory = UserInteractorFactory()
            let interactor = factory.interactor(snake: snake,
                                                field: game.field,
                                                geometry: game.geometry,
                                                control: control)
            if let _interactor = interactor {
                interactors.append(_interactor)
            }
        }
        
        return interactors
    }
}

