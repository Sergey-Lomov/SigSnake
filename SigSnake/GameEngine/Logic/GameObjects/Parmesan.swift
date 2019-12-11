//
//  Parmesan.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/15/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

// Parmesan - most the hardest cheese. Uses in ParmesanSequence and became a ParmesanWall.
class Parmesan : Food {
    var timeLimit:TimeInterval
    
    init(point:Point,
         value:Int = Constants.defaultValue,
         timeLimit:TimeInterval = Constants.defaultTimeLimit) {
        
        self.timeLimit = timeLimit
        let timer = RealtimeTimer(timeLimit: timeLimit)
        super.init(point: point, value: value, lifeTimer: timer)
    }
    
    // MARK: Constants
    private struct Constants {
        static let defaultValue:Int = 3
        static let defaultTimeLimit:TimeInterval = 20
    }
}
