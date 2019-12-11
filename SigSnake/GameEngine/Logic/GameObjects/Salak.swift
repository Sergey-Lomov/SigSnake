//
//  Salak.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/15/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

// Salak - the snake fruit. Main food in game.
class Salak : Food, PointInitialisable {
    required init(point: Point) {
        let value = Constants.defaultValue
        let timer = RealtimeTimer(timeLimit: Constants.defaultTimeLimit)
        super.init(point: point, value: value, lifeTimer: timer)
    }
    
    // MARK: Constants
    private struct Constants {
        static let defaultValue:Int = 1
        static let defaultTimeLimit:TimeInterval = 10
    }
}
