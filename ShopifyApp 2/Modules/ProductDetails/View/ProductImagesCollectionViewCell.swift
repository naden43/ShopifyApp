

//
//  ProductImagesCollectionViewCell.swift
//  ShopifyApp
//
//  Created by Salma on 11/06/2024.
//



import UIKit
import Kingfisher

class ProductImagesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    func configure(with imageUrl: String) {
        if let url = URL(string: imageUrl) {
            productImageView.kf.setImage(with: url)
        }
    }
}
