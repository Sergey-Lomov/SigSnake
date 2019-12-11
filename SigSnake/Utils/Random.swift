//
//  CGFloat+RandomInRange.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/17/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation
import UIKit

extension Float {
    static func random(min:Float, max:Float) -> Float {
        return Float(drand48()) * (max - min) + min
    }
}

extension CGFloat {
    static func random(min:CGFloat, max:CGFloat) -> CGFloat {
        return CGFloat(drand48()) * (max - min) + min
    }
}

extension Int {
    static func random(min:Int, max:Int) -> Int {
        let random = arc4random_uniform(UInt32(max - min + 1))
        return Int(random) + min
    }
}

extension Bool {
    static func random(chance:Float) -> Bool {
        
        // TODO: Resolve randomisation issue. If I use srand all items generates in one step. In another case items generates in strong sequence
//        let time = UInt32(NSDate().timeIntervalSinceReferenceDate)
//        srand48(Int(time))
        let random = drand48()
        return Double(chance) >= random
    }
}

extension Array {
    func randomObject() -> Element? {
        if count == 0 {return nil}
        
        let randomIndex = arc4random_uniform(UInt32(count))
        return self[Int(randomIndex)]
    }
}
