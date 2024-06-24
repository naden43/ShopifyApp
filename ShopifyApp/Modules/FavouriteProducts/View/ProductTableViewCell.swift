//
//  FavouriteProductsTableViewCell.swift
//  ShopifyApp
//
//  Created by Salma on 14/06/2024.
//


import UIKit

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var priceCurrency: UILabel!
    @IBOutlet weak var productSize: UILabel!
    @IBOutlet weak var productColor: UILabel!
    @IBOutlet weak var brand: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var favProductImageView: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
 
    @IBOutlet weak var colorText: UILabel!
    
    @IBOutlet weak var sizeText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCellUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupCellUI() {
        contentView.layer.cornerRadius = 20.0
        contentView.layer.masksToBounds = true
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.2
        layer.masksToBounds = false
    }

    override func layoutSubviews() {
        super.layoutSubviews()
      
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
    }
}

