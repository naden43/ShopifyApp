//
//  OrderTableViewCell.swift
//  ShopifyApp
//
//  Created by Aya Mostafa on 19/06/2024.
//

import UIKit

protocol OrderTableViewCellDelegate: AnyObject {
    func didTapDetailsButton(on cell: OrderTableViewCell)
}

class OrderTableViewCell: UITableViewCell {

    var delegate : OrderTableViewCellDelegate?
    @IBOutlet weak var detailsBtn: UIButton!
    @IBOutlet weak var orderDate: UILabel!
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var productsNumber: UILabel!
    @IBOutlet weak var orderNumber: UILabel!
    //@IBOutlet weak var orderImage: UIImageView!
    @IBOutlet weak var currencyTxt: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.cornerRadius = 30
        // Add corner radius
        contentView.layer.cornerRadius = 30
        contentView.layer.masksToBounds = true
        detailsBtn.layer.borderWidth = 1.0
        detailsBtn.layer.borderColor = UIColor.black.cgColor
        detailsBtn.layer.cornerRadius = 15
        detailsBtn.clipsToBounds = true
        // Add shadow
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.2
        layer.masksToBounds = false
    }
    
    @IBAction func orderDetailsAction(_ sender: Any) {
        print("the details button clicked.........")
        detailsBtn.layer.borderColor = UIColor.orange.cgColor
        detailsBtn.setTitleColor(.orange, for: .selected)
        delegate?.didTapDetailsButton(on: self)
        print("the details button clicked.........")
        detailsBtn.layer.borderColor = UIColor.black.cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
