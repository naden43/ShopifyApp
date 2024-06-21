//
//  OrderTableViewCell.swift
//  ShopifyApp
//
//  Created by Aya Mostafa on 19/06/2024.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    @IBOutlet weak var orderDate: UILabel!
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var productsNumber: UILabel!
    @IBOutlet weak var orderNumber: UILabel!
    @IBOutlet weak var orderImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        orderImage.image = UIImage(named: "orderImage.jpeg")
        orderImage.layer.cornerRadius = 20
        self.contentView.layer.cornerRadius = 30
//        self.contentView.layer.borderWidth = 1.0
////        let secColor = UIColor(red: 64.0/255.0, green: 92.0/255.0, blue: 191.0/255.0, alpha: 1.0)
////        self.contentView.layer.borderColor = UIColor.black
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
