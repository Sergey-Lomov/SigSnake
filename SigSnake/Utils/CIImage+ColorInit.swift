//
//  CIImage+ColorInit.swift
//  SigSnake
//
//  Created by Sergey Lomov on 6/3/18.
//  Copyright © 2018 Sergey Lomov. All rights reserved.
//

import Foundation
import UIKit

extension CIImage {
    convenience init?(color:UIColor, size:CGSize) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil}
        
        self.init(cgImage: cgImage, options: nil)
    }
}
