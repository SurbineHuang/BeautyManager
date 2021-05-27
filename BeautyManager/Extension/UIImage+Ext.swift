//
//  UIImage+Ext.swift
//  BeautyManager
//
//  Created by SurbineHuang on 26/5/21.
//

import UIKit

extension UIImage {
    func resize(width: CGFloat) -> UIImage {
        let size = CGSize(width: width,
                          height: self.size.height * width / self.size.width)
        let renderer = UIGraphicsImageRenderer(size: size)
        let newImage = renderer.image { _ in
            self.draw(in: renderer.format.bounds)
        }
        return newImage
    }
}
