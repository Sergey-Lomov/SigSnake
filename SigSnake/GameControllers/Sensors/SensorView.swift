//
//  SensorView.swift
//  SigSnake
//
//  Created by Sergey Lomov on 6/26/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation
import UIKit

typealias PositionHandlingBehavior = (_ sensor:SensorView, _ point:CGPoint, _ inCanvas:UIView) -> ()

class SensorView : UIView {
    var snake:Snake?
    var snakePositionHandling = [PositionHandlingBehavior]()
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        isUserInteractionEnabled = true
    }
    
    func handleSnakePosition(snake: Snake, position:CGPoint, inCanvas:UIView) {
        guard let selfSnake = self.snake else {return}
        if !selfSnake.isEqual(snake) {return}
        
        for behavior in snakePositionHandling {
            behavior(self, position, inCanvas)
        }
    }
}
