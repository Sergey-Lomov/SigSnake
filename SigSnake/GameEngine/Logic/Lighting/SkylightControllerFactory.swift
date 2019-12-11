//
//  SkylightControllerFactory.swift
//  SigSnake
//
//  Created by Sergey Lomov on 6/12/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

class SkylightControllerFactory {
    func defaultController (lightingController: LightingController) -> SkylightController {
        let morningLighting = LightingDescription(color: .clear, power: 0.5)
        let morningTimer = RealtimeTimer(timeLimit: 10)
        let morning = SkylightDaypart(timer: morningTimer, lighting: morningLighting)
        
        let dayLighting = LightingDescription(color: .clear, power: 1.0)
        let dayTimer = RealtimeTimer(timeLimit: 20)
        let day = SkylightDaypart(timer: dayTimer, lighting: dayLighting)
        
        let eveningLighting = LightingDescription(color: .clear, power: 0.5)
        let eveningTimer = RealtimeTimer(timeLimit: 10)
        let evening = SkylightDaypart(timer: eveningTimer, lighting: eveningLighting)
        
        let nightLighting = LightingDescription(color: .clear, power: 0.0)
        let nightTimer = RealtimeTimer(timeLimit: 10)
        let night = SkylightDaypart(timer: nightTimer, lighting: nightLighting)
        
        let dayparts = [day, evening, night, morning]
        let controller = DefaultSkylightController(controller: lightingController,
                                                   dayparts: dayparts,
                                                   frequency: 0.2)
        return controller
    }
}
