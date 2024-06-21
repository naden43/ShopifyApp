//
//  FavouriteProductsTableViewCell.swift
//  ShopifyApp
//
//  Created by Salma on 14/06/2024.



import UIKit

class FavouriteProductsTableViewCell: UITableViewCell {

    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var favProductImageView: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCellUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupCellUI() {
        // Add corner radius
        contentView.layer.cornerRadius = 40.0
        contentView.layer.masksToBounds = true
        
        // Add border
        contentView.layer.borderColor = UIColor.white.cgColor
        contentView.layer.borderWidth = 20.0
        
        // Add shadow
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.9
        layer.shadowRadius = 4.0
        layer.masksToBounds = false
    }

    override func layoutSubviews() {
        super.layoutSubviews()
      
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
    }
}

