//
//  FavouriteProductsTableViewCell.swift
//  ShopifyApp
//
//  Created by Salma on 14/06/2024.
//

import UIKit

class FavouriteProductsTableViewCell: UITableViewCell {

    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var favProductImageView: UIImageView!
    
    @IBOutlet weak var productTitle: UILabel!
    
    @IBOutlet weak var productBrand: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
