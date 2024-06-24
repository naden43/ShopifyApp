//
//  ReviewsCollectionViewCell.swift
//  ShopifyApp
//
//  Created by Salma on 12/06/2024.
//

import UIKit
import Cosmos

class ReviewsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var reviewerRate: UIView!
    
    @IBOutlet weak var reviewerName: UILabel!
    var cosmosView: CosmosView!
    override func awakeFromNib() {
        super.awakeFromNib()

        cosmosView = CosmosView()
        cosmosView.settings.fillMode = .half
        cosmosView.settings.starSize = 16
        cosmosView.settings.starMargin = 2
        cosmosView.settings.filledColor = .yellow
        cosmosView.settings.emptyBorderColor = .yellow
        cosmosView.settings.filledBorderColor = .yellow
        
        reviewerRate.addSubview(cosmosView)
        
        cosmosView.translatesAutoresizingMaskIntoConstraints = false
        cosmosView.leadingAnchor.constraint(equalTo: reviewerRate.leadingAnchor).isActive = true
        cosmosView.trailingAnchor.constraint(equalTo: reviewerRate.trailingAnchor).isActive = true
        cosmosView.topAnchor.constraint(equalTo: reviewerRate.topAnchor).isActive = true
        cosmosView.bottomAnchor.constraint(equalTo: reviewerRate.bottomAnchor).isActive = true
        personImageView.layer.cornerRadius = personImageView.frame.width / 2
        personImageView.clipsToBounds = true
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.lightGray.cgColor
        layer.cornerRadius = 8.0
    }
    
    func configure(with review: Review) {
        personImageView.image = review.personImage
        commentLabel.text = review.comment
        cosmosView.rating = review.rate
        reviewerName.text = review.reviewerName
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        personImageView.layer.cornerRadius = personImageView.frame.width / 3
    }
}
