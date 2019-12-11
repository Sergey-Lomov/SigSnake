//
//  InteractionTranslatorsFactory.swift
//  SigSnake
//
//  Created by Sergey Lomov on 6/21/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation

class InteractionTranslatorsFactory {
    typealias Limit = SolidInteractionTranslator.Limit
    typealias DirectionLimit = SolidInteractionTranslator.DirectionLimit
    
    private let hexagonStep = Float(60).degreesToRadians
    
    func square() -> SolidInteractionTranslator {
        let step = Float(90).degreesToRadians
        
        // Right segment devided to two parts, because overlap 0 degress (from -45 to 45)
        let rightTopLimit = Limit(min: 0.0,
                                  max: 0.5 * step)
        let upLimit = Limit(min: 0.5 * step,
                            max: 1.5 * step)
        let leftLimit = Limit(min: 1.5 * step,
                              max: 2.5 * step)
        let downLimit = Limit(min: 2.5 * step,
                              max: 3.5 * step)
        let rightBottomLimit = Limit(min: 3.5 * step,
                                     max: 4.0 * step)
        
        let up = DirectionLimit(direction: SquareDirection.up, limit: upLimit)
        let left = DirectionLimit(direction: SquareDirection.left, limit: leftLimit)
        let down = DirectionLimit(direction: SquareDirection.down, limit: downLimit)
        let rightTop = DirectionLimit(direction: SquareDirection.right,
                                      limit: rightTopLimit)
        let rightBottom = DirectionLimit(direction: SquareDirection.right,
                                         limit: rightBottomLimit)
        let limits = [up, left, down, rightTop, rightBottom]
        
        return SolidInteractionTranslator(limits: limits,
                                          defaultDirection: SquareDirection.zero)
    }
    
    func pointyHexagon() -> SolidInteractionTranslator {
        let rotation = Float(30).degreesToRadians
        var limits =  hexagonBasicLimits(rotation: rotation)
        
        let bottomRightBottomLimit = Limit(min: rotation + 5 * hexagonStep,
                                           max: Float(360).degreesToRadians)
        let bottomRightBottomPart = DirectionLimit(direction: HexagonDirection.rightBottom,
                                                   limit: bottomRightBottomLimit)
        let topRightBottomLimit = Limit(min: 0,
                                        max: rotation)
        let topRightBottomPart = DirectionLimit(direction: HexagonDirection.rightBottom,
                                                limit: topRightBottomLimit)
        limits.append(bottomRightBottomPart)
        limits.append(topRightBottomPart)
        
        return SolidInteractionTranslator(limits: limits,
                                          defaultDirection: HexagonDirection.zero)
    }
    
    func flatHexagon() -> SolidInteractionTranslator {
        var limits = hexagonBasicLimits(rotation: 0)
        
        let rightBottomLimit = Limit(min: 5 * hexagonStep,
                                     max: 6 * hexagonStep)
        let rightBottom = DirectionLimit(direction:HexagonDirection.rightBottom,
                                         limit:rightBottomLimit)
        limits.append(rightBottom)
        
        return SolidInteractionTranslator(limits: limits,
                                          defaultDirection: HexagonDirection.zero)
    }
    
    // Returns limits for "up", "leftTop", "leftBottom", "down" and "rightTop" directions. Limits for last direction (rightBotom) is different for pointy and flat hexagon system.
    private func hexagonBasicLimits(rotation: Float) -> [DirectionLimit] {
        let step = hexagonStep
        
        let rightTopLimit = Limit(min: rotation + 0,
                                  max: rotation + step)
        let upLimit = Limit(min: rotation + step,
                            max: rotation + 2 * step)
        let leftTopLimit = Limit(min: rotation + 2 * step,
                                 max: rotation + 3 * step)
        let leftBottomLimit = Limit(min: rotation + 3 * step,
                                    max: rotation + 4 * step)
        let downLimit = Limit(min: rotation + 4 * step,
                              max: rotation + 5 * step)
        
        let rightTop = DirectionLimit(direction: HexagonDirection.rightTop,
                                      limit: rightTopLimit)
        let up = DirectionLimit(direction: HexagonDirection.up,
                                limit: upLimit)
        let leftTop = DirectionLimit(direction: HexagonDirection.leftTop,
                                     limit: leftTopLimit)
        let leftBottom = DirectionLimit(direction: HexagonDirection.leftBottom,
                                        limit: leftBottomLimit)
        let down = DirectionLimit(direction: HexagonDirection.down,
                                  limit: downLimit)

        return [rightTop, up, leftTop, leftBottom, down]
    }
}
