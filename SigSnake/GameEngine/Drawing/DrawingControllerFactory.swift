//
//  DrawingControllerFactory.swift
//  SigSnake
//
//  Created by Sergey Lomov on 5/10/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation
import UIKit

class DrawingControllerFactory {
    func drawing(forGame game:GameController, canvasView:UIView) -> DrawingController? {
        let colorMap = ColorMapFactory().defaultMap()
        let drawing = DrawingController(canvasView: canvasView,
                                        colorMap: colorMap,
                                        game: game)
        
        drawing?.register(drawerType: SquareFieldDrawer.self,
                          forEntityType: SquareField.self)
        drawing?.register(drawerType: HexagonFieldDrawer.self,
                          forEntityType: HexagonField.self)
        drawing?.register(drawerType: SnakeDrawer.self,
                          forEntityType: DefaultSnake.self)
        drawing?.register(drawerType: CorpseDrawer.self,
                          forEntityType: CorpseSegment.self)
        
        drawing?.register(drawerType: SalakDrawer.self,
                          forEntityType: Salak.self)
        drawing?.register(drawerType: WallDrawer.self,
                          forEntityType: Wall.self)
        
        drawing?.register(drawerType: FreezerDrawer.self,
                          forEntityType: Freezer.self)
        drawing?.register(drawerType: AcceleratorDarwer.self,
                          forEntityType: Accelerator.self)
        drawing?.register(drawerType: UraborosDrawer.self,
                          forEntityType: Uraboros.self)
        
        drawing?.register(drawerType: ParmesanDrawer.self,
                          forEntityType: Parmesan.self)
        drawing?.register(drawerType: ParmesanWallDrawer.self,
                          forEntityType: ParmesanWall.self)
        drawing?.register(drawerType: YogurtDrawer.self,
                          forEntityType: Yogurt.self)
        drawing?.register(drawerType: FermentedYogurtDrawer.self,
                          forEntityType: FermentedYogurt.self)
        
        drawing?.register(drawerType: MedusaVirusDrawer.self,
                          forEntityType: MedusaVirus.self)
        
        return drawing
    }
}
