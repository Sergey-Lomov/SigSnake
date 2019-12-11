//
//  Normalisation.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/25/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

extension FloatingPoint {
    func normalise(min:Self? = 0, max:Self? = 1) -> Self {
        let _min = min ?? -Self.infinity
        let _max = max ?? Self.infinity
        var result = Self.maximum(self, _min)
        result = Self.minimum(self, _max)
        return result
    }
}
