//
//  PauseManagerWrapper.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/14/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

// Provide default behavior for classes, which wrap pause managers
protocol PauseManagerWrapper {
    var pauseManager:ReasonsManager<String> {get}
    
    func pause(withKey key:String)
    func resume(withKey key:String)
}

extension PauseManagerWrapper {
    func pause(withKey key:String) {
        pauseManager.addReason(key)
    }
    
    func resume(withKey key:String) {
        pauseManager.removeReason(key)
    }
}
