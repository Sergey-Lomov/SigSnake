//
//  ParmesanWallDrawer.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/15/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

class ParmesanWallDrawer : GameObjectDrawer {
    required init?(entity: Any, colorMap: ColorMap, mapper:GeometryMapper) {
        super.init(entity: entity, colorMap: colorMap, mapper: mapper)
        setBackgroundColor(colorMap.parmesanWallColor.cgColor)
    }
}
