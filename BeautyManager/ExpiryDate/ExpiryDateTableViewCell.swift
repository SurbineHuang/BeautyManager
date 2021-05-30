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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setData(name: String) {
        self.expiredImageView.isHidden = true
        print("===setData \(name)")
        self.productLabel.text = name
    }
}
