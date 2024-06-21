//
//  ProducCollectionViewCell.swift
//  ShopifyApp
//
//  Created by Aya Mostafa on 11/06/2024.
//


// ProducCollectionViewCell.swift


import UIKit

class ProducCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productSubTitle: UILabel!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var currencyTxt: UILabel!

    var viewModel: ProductDetailsViewModel?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func favButton(_ sender: Any) {
        guard let viewModel = viewModel else {
            return
        }

        let isInFavorites = viewModel.isProductInFavorites()
        if isInFavorites {
            viewModel.deleteProductFromDraftOrder(productId: viewModel.selectedProduct?.id ?? 0) { [weak self] success in
                DispatchQueue.main.async {
                    if success {
                        self?.updateFavoriteButtonState(isFavorite: false)
                        self?.reloadFavorites()
                    } else {
                        // Handle error if needed
                    }
                }
            }
        } else {
            viewModel.addSelectedProductToDraftOrder { [weak self] success, message in
                DispatchQueue.main.async {
                    if success {
                        self?.updateFavoriteButtonState(isFavorite: true)
                        self?.reloadFavorites()
                    } else {
                        // Handle error if needed
                    }
                }
            }
        }
    }

    private func reloadFavorites() {
        viewModel?.getFavViewModel()?.loadData { [weak self] in
            DispatchQueue.main.async {
                // Optionally reload the cell or collection view if needed
                let isFavorite = self?.viewModel?.isProductInFavorites() ?? false
                self?.updateFavoriteButtonState(isFavorite: isFavorite)
            }
        }
    }

    func configure(with productDetailsViewModel: ProductDetailsViewModel?) {
        self.viewModel = productDetailsViewModel
        viewModel?.loadFavorites { [weak self] in
            DispatchQueue.main.async {
                let isFavorite = self?.viewModel?.isProductInFavorites() ?? false
                self?.updateFavoriteButtonState(isFavorite: isFavorite)
            }
        }
    }

    private func updateFavoriteButtonState(isFavorite: Bool) {
        let favImage = isFavorite ? UIImage(named: "filledHeart") : UIImage(systemName: "heart")
        favButton.setImage(favImage, for: .normal)
    }
}
