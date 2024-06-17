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
    @IBOutlet weak var productRateView: UIView!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productAvailableSizes: UILabel!
    @IBOutlet weak var productInventoryQuantity: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 30
        contentView.layoutMargins.left = 16
        contentView.layoutMargins.right = 16
        
        separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func btnAddToCart(_ sender: Any) {
        // Handle add to cart action
    }
    
    func configure(with product: Product) {
        productTitleLabel.text = product.title
        productPrice.text = "$\(product.variants?.first?.price ?? "0.00")"
        productInventoryQuantity.text = "Quantity: \(product.variants?.first?.inventoryQuantity ?? 0)"
        
        if let sizes = product.options?.first(where: { $0.name?.lowercased() == "size" })?.values {
            let sizesCount = sizes.count
            productAvailableSizes.text = "Sizes: \(sizesCount) available"
        } else {
            productAvailableSizes.text = "Sizes: N/A"
        }
        
        if let imageUrl = product.image?.src, let url = URL(string: imageUrl) {
            productImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        } else {
            productImageView.image = UIImage(named: "placeholder")
        }
    }
}

