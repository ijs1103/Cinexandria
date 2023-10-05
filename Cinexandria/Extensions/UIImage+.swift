//
//  UIImage+.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/10/05.
//

import UIKit

extension UIImage {
    
    func resize(to size: CGSize) -> UIImage? {
        
        let widthRatio  = size.width  / size.width
        let heightRatio = size.height / size.height
        
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        let rect = CGRect(origin: .zero, size: newSize)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
