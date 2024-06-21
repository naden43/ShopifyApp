//
//  ProducCollectionViewCell.swift
//  ShopifyApp
//
//  Created by Aya Mostafa on 11/06/2024.
//

import UIKit

class ProducCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var favButton: UIButton!
    
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productSubTitle: UILabel!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var currencyTxt: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

