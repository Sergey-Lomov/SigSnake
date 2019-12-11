//
//  ParmesanWall.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/15/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

//Need separate class for use on pair with original drawer
class ParmesanWall : Wall {
    override var collisionMessageKey:String {return "parmesan_wall_collision"}
}
