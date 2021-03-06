//
//  ExpiryDateTableViewCell.swift
//  BeautyManager
//
//  Created by SurbineHuang on 19/5/21.
//

import UIKit

class ExpiryDateTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var expiredImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.selectionStyle = .none
        self.productImage.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        // Configure the view for the selected state
        super.setSelected(selected, animated: animated)

    }
    // 把 product 帶進來
    func setData(product: Product) {
        
        self.productLabel.text = product.name
    
        let now = Date().timeIntervalSince1970
        let oneDaySeconds: Double = 24*60*60
        let day = Int((product.expiryDate - now) / oneDaySeconds) + 1  // day 的單位是(天)
        self.dateLabel.text = "\(day)"
        
        if day <= 0 {
            self.expiredImageView.isHidden = false
        } else {
            self.expiredImageView.isHidden = true
        }
    }
}
