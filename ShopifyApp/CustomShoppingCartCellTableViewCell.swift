//
//  CustomShoppingCartCellTableViewCell.swift
//  ShopifyApp
//
//  Created by Naden on 30/05/2024.
//

import UIKit

class CustomShoppingCartCellTableViewCell: UITableViewCell {

    @IBOutlet weak var plusImage: UIImageView!
    @IBOutlet weak var itemCount: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var minusImage: UIImageView!
    @IBOutlet weak var productDescription: UILabel!
    
    var plusAction : (()->Void) = {}
    var minusAction : (()->Void) = {}
    


    override func awakeFromNib() {
        super.awakeFromNib()
        
        let plusTapGesture = UITapGestureRecognizer(target: self, action: #selector(incrementProductCount))
        plusImage.addGestureRecognizer(plusTapGesture)
        plusImage.isUserInteractionEnabled = true
        
        let minusTapGesture = UITapGestureRecognizer(target: self, action: #selector(decrementProductCount))
        minusImage.addGestureRecognizer(minusTapGesture)
        minusImage.isUserInteractionEnabled = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @objc func incrementProductCount() {
        
             

            plusAction()
    }
   
    @objc func decrementProductCount() {
        minusAction()
    }
    
    
    
   
}
