//
//  UIColor+Ext.swift
//  BeautyManager
//
//  Created by SurbineHuang on 13/6/21.
//

import UIKit

extension UIColor {
    
    static var random: UIColor {
        return UIColor(red: .random(in: 0...1),
                       green: .random(in: 0...1),
                       blue: .random(in: 0...1),
                       alpha: 1.0)
    }
    
    // swiftlint:disable identifier_name
    class func RGBA(r: Int, g: Int, b: Int, a: CGFloat = 1.0) -> UIColor {
        let redFloat = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue = CGFloat(b) / 255.0
        return UIColor(red: redFloat, green: green, blue: blue, alpha: a)
    }
    // swiftlint:enable identifier_name
}
