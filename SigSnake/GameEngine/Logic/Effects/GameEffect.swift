//
//  GameEffect.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/16/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

// Abstract base class for game effects
class GameEffect<ReasonType: Equatable> : GameEventMutator, Equatable {
    private let id = UUID().uuidString
    var reasonsManager = ReasonsManager<ReasonType>()
    var controller:GameController
    var isEnable:Bool {return reasonsManager.isActive}
    
    init(controller:GameController) {
        self.controller = controller
        addToHolder()
    }
    
    func mutateEvent(_ event:GameEvent) -> GameEvent {
        return event
    }
    
    func addReason(_ reason:ReasonType) {
        reasonsManager.addReason(reason)
    }
    
    func removeReason(_ reason:ReasonType) {
        reasonsManager.removeReason(reason)
    }
    
    func addToHolder () {
        controller.addEventMutator(self)
    }
    
    static func == (lhs: GameEffect<ReasonType>, rhs: GameEffect<ReasonType>) -> Bool {
        return lhs.id == rhs.id
    }
}
