//
//  CustomAddreesCell.swift
//  ShopifyApp
//
//  Created by Naden on 30/05/2024.
//

import UIKit

class CustomAddreesCell: UITableViewCell {

    @IBOutlet weak var contentViewOfCell: UIView!
    @IBOutlet weak var cityTxt: UILabel!
    @IBOutlet weak var countryTxt: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
