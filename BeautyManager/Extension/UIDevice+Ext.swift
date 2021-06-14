//
//  UIDevice+Ext.swift
//  BeautyManager
//
//  Created by SurbineHuang on 14/6/21.
//

import UIKit

extension UIDevice {
    
    static var isSimulator: Bool {
        return ProcessInfo.processInfo.environment["SIMULATOR_DEVICE_NAME"] != nil
    }
}
