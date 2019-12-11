//
//  DefaultSkylightController.swift
//  SigSnake
//
//  Created by Sergey Lomov on 6/12/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

class DefaultSkylightController : SkylightController, GameTimerDelegate, PauseManagerWrapper, ReasonsManagerDelegate {

    var pauseManager = ReasonsManager<String>()
    var controller: LightingController
    var frequency: TimeInterval
    var dayparts: [SkylightDaypart]
    
    private var currentDaypart:SkylightDaypart?
    private var gradientTimer:Timer?
    private var lightingSource:AmbientLightingSource
    
    private let pauseKey = "paused_by_skylight_controller"
    private let errorPauseKey = "selfpaused_by_error"
    
    init(controller:LightingController,
         dayparts:[SkylightDaypart],
         frequency:TimeInterval) {
        
        self.controller = controller
        self.dayparts = dayparts
        self.frequency = frequency
        
        self.lightingSource = AmbientLightingSource(power: 0,
                                                    color: .clear)
        pauseManager.delegate = self
    }
    
    func start() {
        controller.removeAmbientSource(lightingSource)
        controller.addAmbientSource(lightingSource)
        
        guard let firstDaypart = dayparts.first else {return}
        executeDaypart(firstDaypart)
        
        gradientTimer = Timer.scheduledTimer(withTimeInterval: frequency,
                                             repeats: true,
                                             block: {_ in
                                                self.updateLighting()
        })
    }
    
    // MARK: Pause manager delegate
    func reasonsManagerDidActivate(id: String) {
        currentDaypart?.timer.pause(withKey: pauseKey)
    }
    
    func reasonsManagerDidDeactivate(id: String) {
        currentDaypart?.timer.resume(withKey: pauseKey)
    }
    
    // MARK: Game timer delegate
    func gameTimerFinished(_ timer: GameTimer) {
        if let currentDaypart = currentDaypart,
            let nextDaypart = nextDaypartFor(currentDaypart) {
            executeDaypart(nextDaypart)
        } else {
            pause(withKey: errorPauseKey)
        }
    }
    
    // MAKR: Private
    func updateLighting () {
        guard let currentDaypart = currentDaypart,
            let nextDaypart = nextDaypartFor(currentDaypart),
            let previousDaypart = previousDaypartFor(currentDaypart)
            else {return}
        
        let timeLeft = currentDaypart.timer.timeLeft()
        let duration = currentDaypart.timer.duration()
        let index = Float(1 - timeLeft / duration)
        
        // If index is less than half should be calculated gradient between previous and current dayparts. In other case - between current and next dayparts.
        let fromDaypart = index > 0.5 ? currentDaypart : previousDaypart
        let toDaypart = index > 0.5 ? nextDaypart : currentDaypart
        let relativeIndex = index > 0.5 ? index - 0.5 : index + 0.5
        let fromLighting = fromDaypart.lighting
        let toLighting = toDaypart.lighting
        
        let lighting = LightingDescription.gradientLighting(from: fromLighting,
                                                            to: toLighting,
                                                            index: relativeIndex)
        lightingSource.lighting = lighting
        controller.updateAmbientSource(lightingSource)
    }
    
    func executeDaypart (_ daypart:SkylightDaypart) {
        currentDaypart = daypart
        daypart.timer.delegate = self
        daypart.timer.start()
    }
    
    func nextDaypartFor(_ dypart:SkylightDaypart) -> SkylightDaypart? {
        guard let index = dayparts.index(of: dypart) else {return nil}
        let newIndex = index < dayparts.count - 1 ? index + 1 : 0
        return dayparts[newIndex]
    }
    
    func previousDaypartFor(_ dypart:SkylightDaypart) -> SkylightDaypart? {
        guard let index = dayparts.index(of: dypart) else {return nil}
        let newIndex = index > 0 ? index - 1 : dayparts.count - 1
        return dayparts[newIndex]
    }
}
