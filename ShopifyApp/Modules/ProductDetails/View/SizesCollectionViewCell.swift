//
//  SizesCollectionViewCell.swift
//  ShopifyApp
//
//  Created by Salma on 11/06/2024.
//

/*import UIKit

class SizesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var productSize: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Decrease border width
        productSize.layer.borderWidth = 0.2 // Adjust as needed
        
        // Increase height
        let currentHeight = productSize.frame.height
        let desiredHeight: CGFloat = 40.0 // Adjust as needed
        let heightDiff = desiredHeight - currentHeight
        
        // Adjust label height constraint
        productSize.frame.size.height = desiredHeight
        
        // Adjust corner radius
        productSize.layer.cornerRadius = 2.0 // Adjust as needed
        productSize.layer.masksToBounds = true
    }
}
*/

import UIKit

class SizesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var productSize: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Adjusting border properties
        productSize.layer.borderColor = UIColor.gray.cgColor
        productSize.layer.borderWidth = 0.2 
        
        let currentHeight = productSize.frame.height
        let desiredHeight: CGFloat = 40.0 // Adjust as needed
        let heightDiff = desiredHeight - currentHeight
        
    
        productSize.layer.cornerRadius = 2.0
        productSize.layer.masksToBounds = true
        
        // Ensuring the bottom border is visible
        productSize.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
}


