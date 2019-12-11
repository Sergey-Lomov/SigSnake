//
//  SnakeBodyDrawer.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/10/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation
import UIKit

class SnakeBodyDrawer : GameObjectDrawer {
    required init?(entity: Any, colorMap: ColorMap, mapper:GeometryMapper) {
        super.init(entity: entity, colorMap: colorMap, mapper: mapper)
        setBackgroundColor(colorMap.snakeBodyColor.cgColor)
    }
}
