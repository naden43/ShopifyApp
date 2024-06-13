//
//  SizesCollectionViewCell.swift
//  ShopifyApp
//
//  Created by Salma on 11/06/2024.
//

import UIKit

class SizesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var productSize: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        productSize.layer.borderColor = UIColor.gray.cgColor
        productSize.layer.borderWidth = 1.0
        productSize.layer.cornerRadius = 8.0
        productSize.layer.masksToBounds = true
    }
}
