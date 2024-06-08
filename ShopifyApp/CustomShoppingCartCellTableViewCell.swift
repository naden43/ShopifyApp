//
//  CustomShoppingCartCellTableViewCell.swift
//  ShopifyApp
//
//  Created by Naden on 30/05/2024.
//

import UIKit

class CustomShoppingCartCellTableViewCell: UITableViewCell {

    @IBOutlet weak var itemCount: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
   
}
