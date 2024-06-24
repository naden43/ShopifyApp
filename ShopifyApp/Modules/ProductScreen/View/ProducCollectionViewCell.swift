

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

    var performFavError : (()->Void) = {}
    var viewModel: ProductDetailsViewModel?
    var reloadCollection : (()->Void) = {}
    
    var presentAlertDeletion : ((UIAlertController)->Void) = {_ in }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func favButton(_ sender: Any) {
        print("presses")
        guard let viewModel = viewModel else {
            return
        }

        if UserDefaultsManager.shared.getCustomer().id != nil {
            
            let isInFavorites = viewModel.isProductInFavorites()
            if isInFavorites {
                
                let alert = UIAlertController(title: "Delete", message: "Are you sure you want to remove product from favourites ", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                
                alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { action  in
                    
                    viewModel.deleteProductFromFavDraftOrder(productId: viewModel.selectedProduct?.id ?? 0) { [weak self] success in
                        DispatchQueue.main.async {
                            if success {
                                self?.updateFavoriteButtonState(isFavorite: false)
                                self?.reloadFavorites()
                            } else {
                                // Handle error if needed
                            }
                        }
                    }
                     
                }))
                
                presentAlertDeletion(alert)
                
            } else {
                viewModel.addSelectedProductToDraftOrder (varientID: viewModel.selectedProduct?.variants?.first?.id ?? 0 ){ [weak self] success, message in
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
        else
        {
            performFavError()
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
        let favImage = isFavorite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        favButton.setImage(favImage, for: .normal)
    }
}
