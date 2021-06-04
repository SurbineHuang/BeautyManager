//
//  TabBarViewController.swift
//  BeautyManager
//
//  Created by SurbineHuang on 28/5/21.
//

import UIKit

class TabBarViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 檢查每個產品的過期時間, 將即將過期的產品名稱, 組成一個字串
//                var willExpiredProductNames = ""
//
//                products.forEach { (product) in
//                    let now = Date().timeIntervalSince1970
//                    let oneDaySeconds: Double = (24 * 60 * 60)
//                    let willExpired = (product.expiryDate - now) < (oneDaySeconds * 30)
//                    if (willExpired) {
//                        willExpiredProductNames.append(product.name)
//                        willExpiredProductNames.append("\n")
//                    }
//                }
//
//                let expiredProducts = willExpiredProductNames
//                self?.showExpiredWarningAlert(message: expiredProducts)
    }
}
