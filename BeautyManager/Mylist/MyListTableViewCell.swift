//
//  MyListTableViewCell.swift
//  BeautyManager
//
//  Created by SurbineHuang on 13/5/21.
//

import UIKit

class MyListTableViewCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var productLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        self.productImageView.layer.cornerRadius = 8
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    func setData(name: String, photoUrlString: String, brand: String, type: String, expiryDate: String) {
        
        self.productLabel.text = name
        self.brandLabel.text = brand
        self.typeLabel.text = type
        self.dateLabel.text = expiryDate
        
    }
}

