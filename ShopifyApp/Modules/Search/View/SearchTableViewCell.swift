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
        setupCellUI()
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
    
    private func setupCellUI() {
        contentView.layer.cornerRadius = 20.0
        contentView.layer.masksToBounds = true
     
        if let customShadowColor = UIColor(named: "tentColor") {
            layer.shadowColor = customShadowColor.cgColor
        } else {
            layer.shadowColor = UIColor.black.cgColor
        }
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 40
        layer.masksToBounds = false
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
    }
}

 

