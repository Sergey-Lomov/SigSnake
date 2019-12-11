//
//  GeometryMapperFactory.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/29/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation
import UIKit

// This class handle connection between geometries and mappers
class GeometryMapperFactory {
    private var mappers = [String : GeometryMapper.Type]()
    
    init() {
        register(mapper: SquareGeometryMapper.self,
                 forGeometry: SquareGeometry.self)
        register(mapper: FlatHexagonGeometryMapper.self,
                 forGeometry: FlatHexagonGeometry.self)
        register(mapper: PointyHexagonGeometryMapper.self,
                 forGeometry: PointyHexagonGeometry.self)
    }
    
    func mapper(forGeometry geometry:Geometry,
                field:Field,
                canvasSize:CGSize) -> GeometryMapper? {
        let geometryType = type(of: geometry)
        if let mapperType = mappers[String(describing: geometryType)] {
            return mapperType.init(field: field, canvasSize: canvasSize)
        }
        return nil
    }
    
    private func register(mapper:GeometryMapper.Type,
                          forGeometry geometry:Geometry.Type) {
        mappers[String(describing: geometry)] = mapper
    }
}
