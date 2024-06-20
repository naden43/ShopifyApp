//
//  ProductCollectionViewCell.swift
//  ShopifyApp
//
//  Created by Aya Mostafa on 02/06/2024.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var favBtn: UIImageView!
    @IBOutlet weak var priceCurrency: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productSubtitle: UILabel!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
