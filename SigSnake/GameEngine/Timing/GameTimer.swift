//
//  GameTimer.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/13/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

protocol GameTimerDelegate {
    func gameTimerFinished(_ timer:GameTimer)
}

// Game timer not handle time for delegate calling.
// Objects of this class may only response to requests from other objects.
// It is abstract class which contains default realisation of pause effects and Equtable protocol
class GameTimer : Equatable, ReasonsManagerDelegate, PauseManagerWrapper {
    private var id = UUID().uuidString
    
    var pauseManager = ReasonsManager<String>()
    var delegate:GameTimerDelegate? = nil
    
    var isPaused:Bool {return pauseManager.isActive}

    init() {
        pauseManager.delegate = self
    }
    
    static func == (lhs: GameTimer, rhs: GameTimer) -> Bool {
        return lhs.id == rhs.id
    }
    
    // MARK: Methods for overriding
    
    func start() {
        assert(false, "GameTimer is abstract class")
    }
    
    func reset() {
        assert(false, "GameTimer is abstract class")
    }

    func reasonsManagerDidActivate(id: String) {
        if id == pauseManager.id {
            pause()
        }
    }
    
    func reasonsManagerDidDeactivate(id: String) {
        if id == pauseManager.id {
            resume()
        }
    }
    
    func timeLeft () -> TimeInterval {
        assert(false, "GameTimer is abstract class")
        return 0
    }
    
    func duration () -> TimeInterval {
        assert(false, "GameTimer is abstract class")
        return 0
    }
    
    func isLeft() -> Bool {
        return timeLeft() <= 0
    }
    
    func pause() {
        assert(false, "GameTimer is abstract class")
    }
    
    func resume() {
        assert(false, "GameTimer is abstract class")
    }
}

