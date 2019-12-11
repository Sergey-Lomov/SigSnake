//
//  SkylightController.swift
//  SigSnake
//
//  Created by Sergey Lomov on 6/7/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

/// Represent info about daypart like morning, evening and e.t.c
class SkylightDaypart : Equatable {
    private var id = UUID().uuidString
    
    /// Timer, which control daypart duration
    var timer:GameTimer
    
    /// Daypart lgihting. In DefaultSkylightController uses at middle of daypart.
    var lighting:LightingDescription
    
    init(timer:GameTimer, lighting:LightingDescription) {
        self.timer = timer
        self.lighting = lighting
    }
    
    static func == (lhs: SkylightDaypart, rhs: SkylightDaypart) -> Bool {
        return lhs.id == rhs.id
    }
}

/// Main purpose of this protocol - controll skylight chaging during the morning/day/evening/night. Specified LightingController will be called regulary for update lighting.
protocol SkylightController : PauseManagerWrapper {
    
    /// LightingController which will be notified about skylight changing
    var controller: LightingController {get set}
    
    /// Frequency of LightingController calls. Be careful - less value of this property lead to more beautiful lighting changes, but also lead to more often lighting re-calculation.
    var frequency: TimeInterval {get set}
    
    /// Parts of day. It may be everything, not only the morning/day/evening/night.
    var dayparts: [SkylightDaypart] {get set}
    
    /// Start/restart dayparts cycle
    func start()
}
