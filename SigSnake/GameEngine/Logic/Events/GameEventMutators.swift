//
//  GameEventMutators.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/18/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

protocol GameEventMutator {
    var isEnable:Bool {get}
    func mutateEvent(_ event:GameEvent) -> GameEvent
}

protocol SnakeEventMutator : GameEventMutator{
    var snake:Snake {get}
}

protocol EventMutatorsHolder {
    var eventMutators:[GameEventMutator] {get}
    
    func addEventMutator(_ mutator:GameEventMutator)
    func eventMutatorsOfType<T:GameEventMutator>() -> [T]
    
    func mutateEvent(_ event:GameEvent) -> GameEvent
}

extension EventMutatorsHolder {
    func mutateEvent(_ event:GameEvent) -> GameEvent {
        var currentEvent = event
        let activeMutators = eventMutators.filter{return $0.isEnable}
        for mutator in activeMutators {
            currentEvent = mutator.mutateEvent(event)
        }
        
        return currentEvent
    }
    
    func eventMutatorsOfType<T>() -> [T] where T : GameEventMutator {
        return eventMutators.filteredByType()
    }
}
