//
//  MedusaInfectionEffect.swift
//  SigSnake
//
//  Created by Sergey Lomov on 6/15/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

import Foundation

// This class implement logic related to infection progress on snake.
class MedusaInfectionEffect : SnakeEffect<MedusaVirus>, ReasonsManagerDelegate {
    override init(controller: GameController, snake: Snake) {
        super.init(controller: controller, snake: snake)
        
        reasonsManager.delegate = self
    }
    
    func reasonsManagerDidActivate(id:String) {
        snake.corpseConverter = { segment in
            let virus = segment.attachedObjects[MedusaVirus.group]
            if virus != nil {
                return Wall(point: segment.point)
            } else {
                return self.snake.defaultCorpseConverter(segment)
            }
        }
    }
    
    func reasonsManagerDidDeactivate(id:String) {
        snake.corpseConverter = snake.defaultCorpseConverter
    }
}
