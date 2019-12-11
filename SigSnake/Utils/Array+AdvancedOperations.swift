//
//  Array+AdvancedOperations.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/11/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation
import UIKit

extension Array where Element:Equatable {
    mutating func remove(object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
    
    mutating func remove(contentsOf conteiner:[Element]) {
        self = filter {return !conteiner.contains($0)}
    }
}

extension Array {
    func filteredByType<T> () -> [T] {
        let filteredArray = self.filter({ object in
            return object is T
        })
        
        let castArray = filteredArray as? [T]
        return castArray ?? [T]()
    }
}
