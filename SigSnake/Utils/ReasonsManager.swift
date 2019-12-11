//
//  ReasonsManager.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/14/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

protocol ReasonsManagerDelegate {
    func reasonsManagerDidActivate(id:String)
    func reasonsManagerDidDeactivate(id:String)
}

class ReasonsManager<T:Equatable> {
    private var reasons = [T]()
    
    var id:String = UUID().uuidString
    var delegate:ReasonsManagerDelegate?
    
    var isActive:Bool {return reasons.count > 0}
    var firstReason:T? {return reasons.first}
    
    init(delegate:ReasonsManagerDelegate? = nil) {
        self.delegate = delegate
    }
    
    func getReasonsFrom(_ manager:ReasonsManager) {
        reasons.append(contentsOf: manager.reasons)
    }
    
    // Keys uses for identify pause reason
    func addReason(_ reason:T) {
        if !reasons.contains(reason) {
            reasons.append(reason)
            if reasons.count == 1 {
                delegate?.reasonsManagerDidActivate(id: id)
            }
        }
    }
    
    func removeReason(_ reason:T) {
        let wasActive = isActive
        
        reasons.remove(object: reason)
        
        if !isActive && wasActive {
            delegate?.reasonsManagerDidDeactivate(id: id)
        }
    }
}
