//
//  RealtimeTimer.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/13/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

class RealtimeTimer : GameTimer {
    var timeLimit:TimeInterval
    var timer:Timer? = nil
    
    private var fullTimeLimit:TimeInterval
    private var startDate:Date?
    private var pauseDate:Date?

    static var infinityTimer:RealtimeTimer {return RealtimeTimer(timeLimit: .infinity)}
    
    init(timeLimit:TimeInterval) {
        self.timeLimit = timeLimit
        self.fullTimeLimit = timeLimit
    }
    
    override func start() {
        startDate = Date()
        
        timer = Timer.scheduledTimer(withTimeInterval: timeLimit,
                                     repeats: false,
                                     block: { timer in
                                        self.delegate?.gameTimerFinished(self)
        })
        
        if pauseManager.isActive {
            pause()
        }
    }
    
    override func reset() {
        startDate = nil
        pauseDate = nil
        timer?.invalidate()
        timeLimit = fullTimeLimit
    }
    
    override func pause() {
        pauseDate = Date()
        timer?.invalidate()
    }
    
    override func resume() {
        if let _pauseDate = pauseDate {
            timeLimit += Date().timeIntervalSince(_pauseDate)
            pauseDate = nil
            
            timer = Timer(timeInterval: timeLimit,
                          repeats: false,
                          block: { timer in
                            self.delegate?.gameTimerFinished(self)
            })
        }
    }
        
    override func timeLeft() -> TimeInterval {
        guard let startDate = startDate else {return .infinity}
        
        let displacement = Date().timeIntervalSince(pauseDate ?? Date())
        let relativeTime = Date().timeIntervalSince(startDate) - displacement
        
        return timeLimit - relativeTime
    }
    
    override func duration() -> TimeInterval {
        return fullTimeLimit
    }
}
