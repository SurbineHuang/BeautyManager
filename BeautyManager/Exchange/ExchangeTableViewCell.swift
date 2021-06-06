//
//  ExchangeTableViewCell.swift
//  BeautyManager
//
//  Created by SurbineHuang on 25/5/21.
//

import UIKit

class ExchangeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.productImageView.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }
    
    func setData(name: String, expiryDate: String) {
        
        self.productLabel.text = name
        self.dateLabel.text = expiryDate
    }
}
