//
//  LightingColor.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/23/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

class LightingColor {
    static var clear:LightingColor {return LightingColor()}
    
    private let ri = 0
    private let gi = 1
    private let bi = 2
    private let ai = 3
    
    var components:[Float] = [0, 0, 0, 0]
    
    var r:Float {
        get {return components[ri]}
        set {components[ri] = newValue}
    }
    
    var g:Float {
        get {return components[gi]}
        set {components[gi] = newValue}
    }
    
    var b:Float {
        get {return components[bi]}
        set {components[bi] = newValue}
    }
    
    var a:Float {
        get {return components[ai]}
        set {components[ai] = newValue}
    }
    
    init () {}
    
    init(r:Float, g:Float, b:Float, a:Float) {
        self.r = r
        self.g = g
        self.b = b
        self.a = a
    }
    
    init (components:[Float]) {
        if components.count == self.components.count {
            self.components = components
        }
    }
}
