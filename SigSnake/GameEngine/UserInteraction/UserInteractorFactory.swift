//
//  UserInteractorFactory.swift
//  SigSnake
//
//  Created by Sergey Lomov on 6/21/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

enum ControlTypes {
    case joystickView
}

class UserInteractorFactory {
    
    func interactor(snake: Snake,
                    field: Field,
                    geometry: Geometry,
                    control: UserInteractionControl) -> UserInteractor? {
        
        var translator:UserInteractionGeometryTranslator?
        if geometry is SquareGeometry {
            translator = InteractionTranslatorsFactory().square()
        } else if geometry is FlatHexagonGeometry {
            translator = InteractionTranslatorsFactory().flatHexagon()
        } else if geometry is PointyHexagonGeometry {
            translator = InteractionTranslatorsFactory().pointyHexagon()
        }
        
        guard let _translator = translator else {return nil}
        
        return UserInteractor(control: control,
                              translator: _translator,
                              field: field,
                              snake: snake)
    }
}
