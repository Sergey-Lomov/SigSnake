//
//  GameObjectDrawersZGroup.swift
//  SigSnake
//
//  Created by Sergey Lomov on 6/14/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation
import UIKit

enum GameObjectDrawersZGroup : CGFloat {
    case inFieldHightPriority = 3,
    inField = 2,
    inFieldLowPriority = 1,
    attached = -1,
    attachedLowPriority = -2
}
