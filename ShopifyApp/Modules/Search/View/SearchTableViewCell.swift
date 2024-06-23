//
//  SearchTableViewCell.swift
//  ShopifyApp
//
//  Created by Salma on 15/06/2024.
//

import UIKit
import Kingfisher

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productBrand: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configure(with product: Product) {
        productTitleLabel.text = product.title
        productPrice.text = "$\(product.variants?.first?.price ?? "0.00")"
        productBrand.text = product.vendor
        
        if let imageUrl = product.image?.src, let url = URL(string: imageUrl) {
            productImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        } else {
            productImageView.image = UIImage(named: "placeholder")
        }
    }
}
 


