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
        productSize.layer.borderWidth = 0.2
        
        productSize.layer.cornerRadius = 5.0
        productSize.layer.masksToBounds = true
        
        productSize.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        productSize.font = UIFont.systemFont(ofSize: 16.0)
        productSize.textAlignment = .center
    }
    
    override var isSelected: Bool {
        didSet {
            updateSelectionUI()
        }
    }
    private func updateSelectionUI() {
        if isSelected {
            productSize.layer.borderWidth = 2.0
            productSize.layer.borderColor = UIColor.black.cgColor
            productSize.font = UIFont.boldSystemFont(ofSize: 16.0)
        } else {
            productSize.layer.borderWidth = 0.2
            productSize.layer.borderColor = UIColor.gray.cgColor
            productSize.font = UIFont.systemFont(ofSize: 16.0)
        }
    }
   
}



