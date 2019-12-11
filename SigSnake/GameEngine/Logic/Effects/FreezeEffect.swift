//
//  FreezeEffect.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/16/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

class FreezeEffect : GameEffect<Freezer>, ReasonsManagerDelegate {
    
    // Array with all freeze effects prevent situation when two freeze effects freeze each other.
    // At activation effect freezes all objects exclude first reason of each active freeze effects.
    private static var allEffects:[FreezeEffect] = [FreezeEffect]()
    private let pauseKey = "freezEffect"

    override init(controller:GameController) {
        super.init(controller: controller)
        reasonsManager.delegate = self
        FreezeEffect.allEffects.append(self)
    }

    override func removeReason(_ reason: Freezer) {
        super.removeReason(reason)
        
        if let newFirstReason = reasonsManager.firstReason {
            newFirstReason.lifeTimer.resume(withKey: pauseKey)
        }
    }
    
    func reasonsManagerDidActivate(id:String) {
        let objects:[TemporalObject] = controller.objectsOfType()
        
        let activeEffects = FreezeEffect.allEffects.filter {return $0.isEnable}
        let freezers = activeEffects.map {$0.reasonsManager.firstReason}
        
        for object in objects {
            if let freezer = object as? Freezer {
                if freezers.contains(freezer) {
                    continue
                }
            }
            
            object.lifeTimer.pause(withKey: pauseKey)
        }
        
        controller.objectsGenerator.pause(withKey: pauseKey)
    }
    
    func reasonsManagerDidDeactivate(id:String) {
        let objects:[TemporalObject] = controller.objectsOfType()
        
        for object in objects {
            object.lifeTimer.resume(withKey: pauseKey)
        }
        
        controller.objectsGenerator.resume(withKey: pauseKey)
    }
    
    deinit {
        FreezeEffect.allEffects.remove(object: self)
    }
}
