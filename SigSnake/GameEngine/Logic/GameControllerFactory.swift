//
//  GameControllerFabric
//  SigSnake
//
//  Created by Sergey Lomov on 5/10/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

class GameControllerFactory {
    func standardGame() -> GameController {
        let geometry = SquareGeometry()
        
        let fieldSize = Constants.DefaultGame.fieldSize
        let field = SquareField(width: fieldSize, height: fieldSize)
        
        let headPoint = SquarePoint(x: 7, y: 7)
        let head = SnakeHead(point: headPoint,
                             direction: SquareDirection.up)
        var body = [SnakeBody]()
        for i in 1...Constants.DefaultGame.snakeLenght {
            let direction = SquareDirection(x:0, y:i)
            if let bodyPoint = geometry.point(fromPoint: head.point,
                                              withDirection: direction,
                                              inField: field) {
                let bodySegment = SnakeBody(point: bodyPoint)
                body.append(bodySegment)
            }
        }

        let objectsGenerator = ObjectsGeneratorFactory().defaultGenerator()
        let game = DefaultGameController(field: field,
                                         objectsGenerator: objectsGenerator,
                                         geometry: geometry)
        
        let snake = DefaultSnake(controller:game, head: head, body: body)
        game.addSnake(snake)
        
//        let lightingMixer = MaxPowerAverageColorMixer()
//        let lightingController = DefaultLightingController(controller: game,
//                                                           mixer: lightingMixer)
//        game.lightingController = lightingController
        
//        if let freezerPoint = head.point.point(withDirection: SquareDirection(x:-2, y:-2)) {
//            let freezer = Freezer(point: freezerPoint)
//            game.addObject(freezer)
//        }
//
//        let wall1 = Wall(point: SquarePoint(x: 4, y: 5))
//        let wall2 = Wall(point: SquarePoint(x: 5, y: 5))
//        let wall3 = Wall(point: SquarePoint(x: 6, y: 5))
//        let wall4 = Wall(point: SquarePoint(x: 7, y: 5))
//        let wall5 = Wall(point: SquarePoint(x: 8, y: 5))
//        let wall6 = Wall(point: SquarePoint(x: 9, y: 5))
//        game.addObject(wall1)
//        game.addObject(wall2)
//        game.addObject(wall3)
//        game.addObject(wall4)
//        game.addObject(wall5)
//        game.addObject(wall6)
        
        // Test lighting adding
//        let point = SquarePoint(x: 12, y: 10)
//        let color = LightingColor(r: 0, g: 1, b: 0, a: 0.5)
//        let source = PointLightingSource(point: point,
//                                         power: 1.2,
//                                         color: color)
//        lightingController.addPointSource(source)
//
//        let point2 = SquarePoint(x: 16, y: 10)
//        let color2 = LightingColor(r: 0, g: 0, b: 1, a: 0.5)
//        let source2 = PointLightingSource(point: point2,
//                                          power: 1.2,
//                                          color: color2)
//        lightingController.addPointSource(source2)

//        let ambientColor = LightingColor(r: 0, g: 0, b: 0, a: 0.0)
//        let ambientSource = AmbientLightingSource(power: 1.0,
//                                                  color: ambientColor)
//        lightingController.addAmbientSource(ambientSource)
//
//        let factory = SkylightControllerFactory()
//        let skylightController = factory.defaultController(lightingController: lightingController)
//        lightingController.addSkylightController(skylightController)
        
        
        //Test objects added
        let direction5 = SquareDirection(x:-5, y:-3)
        if let point5 = geometry.point(fromPoint: head.point,
                                       withDirection: direction5,
                                       inField: field) {
            let object5 = MedusaVirus(point: point5)
            game.addObject(object5)
        }
        
        for x in 20...28 {
            for y in 0...5 {
                let virus = MedusaVirus(point: SquarePoint(x: x, y: y))
                game.addObject(virus)
            }
        }
        
        // Filed parts removing
        field.removePoints([SquarePoint(x: 0, y: fieldSize - 1),
                            SquarePoint(x: 1, y: fieldSize - 1),
                            SquarePoint(x: 2, y: fieldSize - 1),
                            SquarePoint(x: 3, y: fieldSize - 1),
                            SquarePoint(x: 4, y: fieldSize - 1),
                            SquarePoint(x: 0, y: fieldSize - 2),
                            SquarePoint(x: 1, y: fieldSize - 2),
                            SquarePoint(x: 2, y: fieldSize - 2),
                            SquarePoint(x: 3, y: fieldSize - 2),
                            SquarePoint(x: 0, y: fieldSize - 3),
                            SquarePoint(x: 1, y: fieldSize - 3),
                            SquarePoint(x: 2, y: fieldSize - 3),
                            SquarePoint(x: 0, y: fieldSize - 4),
                            SquarePoint(x: 1, y: fieldSize - 4),
                            SquarePoint(x: 0, y: fieldSize - 5)])
        return game
    }
    
    func hexagonGame() -> GameController {
        let geometry = FlatHexagonGeometry()
        
        let fieldSize = Constants.DefaultGame.fieldSize
        let field = HexagonField(radius: fieldSize / 2)
        
        let headPoint = HexagonPoint(q: 0, r: 0)
        let head = SnakeHead(point: headPoint,
                             direction: HexagonDirection.up)
        var body = [SnakeBody]()
        for i in 1...Constants.DefaultGame.snakeLenght {
            let direction = HexagonDirection(q: 0, r: i)
            if let bodyPoint = geometry.point(fromPoint: head.point,
                                              withDirection: direction,
                                              inField: field) {
                let bodySegment = SnakeBody(point: bodyPoint)
                body.append(bodySegment)
            }
        }
        
        let objectsGenerator = ObjectsGeneratorFactory().defaultGenerator()
        let game = DefaultGameController(field: field,
                                         objectsGenerator: objectsGenerator,
                                         geometry: geometry)
        
        let snake = DefaultSnake(controller:game, head: head, body: body)
        game.addSnake(snake)
        
        //Test objects added
        let point1 = HexagonPoint(q:-2, r:-2)
        let object1 = Uraboros(point: point1)
        game.addObject(object1)
        
        let point2 = HexagonPoint(q:-3, r:-2)
        let object2 = Uraboros(point: point2)
        game.addObject(object2)
        
        let point3 = HexagonPoint(q:-4, r:-2)
        let object3 = Parmesan(point: point3)
        game.addObject(object3)
        
        let point4 = HexagonPoint(q:-5, r:-2)
        let object4 = Parmesan(point: point4)
        game.addObject(object4)
        
//        for q in 0 ... 3 {
//            for r in -10 ... -7 {
//                let virus = MedusaVirus(point: HexagonPoint(q: q, r: r))
//                game.addObject(virus)
//            }
//        }
        
        return game
        
    }
    
    // MARK: Constants
    private struct Constants {
        struct DefaultGame {
            static let fieldSize:Int = 20
            static let snakeLenght:Int = 5
        }
    }
}
