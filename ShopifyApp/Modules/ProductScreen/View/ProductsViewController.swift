//  ProductsViewController.swift
//  ShopifyApp
//
//  Created by Aya Mostafa on 02/06/2024.
//

import UIKit
import Kingfisher

class ProductsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var productCollection: UICollectionView!
    @IBOutlet weak var bName: UILabel!
    var brandId: Int?
    var brandName: String?
    var viewModel: HomeViewModelProtocol?
    var productDetailsViewModel: ProductDetailsViewModel?
    var url: String = ""
    let activityIndicator = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
        url = "/admin/api/2024-04/products.json?collection_id=\(self.brandId ?? 0)"
        viewModel = HomeViewModel()
        productCollection.dataSource = self
        productCollection.delegate = self
        
        let nib = UINib(nibName: "ProducCollectionViewCell", bundle: nil)
        productCollection.register(nib, forCellWithReuseIdentifier: "productCell")
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            switch sectionIndex {
            case 0:
                return self.productsSectionLayout()
            default:
                return nil
            }
        }
        productCollection.collectionViewLayout = layout
        
        viewModel?.bindToProductViewController = { [weak self] in
            self?.activityIndicator.stopAnimating()

            DispatchQueue.main.async {
                self?.productCollection.reloadData()
                self?.bName.text = self?.brandName
            }
        }
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.activityIndicator.center = self.view.center
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()
        viewModel?.fetchProducts(url: url)
        viewModel?.loadFavProducts()
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.getProductsOfBrands().count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let productCell = productCollection.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! ProducCollectionViewCell
        
        
        productCell.productImage.layer.cornerRadius = 20

        
        guard let products = viewModel?.getProductsOfBrands() else {
            return productCell
        }

        productCell.performFavError = {
            let alert = UIAlertController(title: "Guest", message: "You are not a user please login or reguster first ", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            alert.addAction(UIAlertAction(title: "Login \\ Register", style: .default, handler: { action in
                
                let part3Storyboard = UIStoryboard(name: "Part3", bundle: nil)
                
                let chooseScreen = part3Storyboard.instantiateViewController(withIdentifier: "choose_screen")
            
                self.present(chooseScreen, animated: true)
            
            }))
            self.present(alert, animated: true)
        }
        
        let product = products[indexPath.row]
       //productCell.productTitle.text = product.title
        
        let price = viewModel?.convertPriceByCurrency(price: Double(product.variants?.first?.price ?? "0") ?? 0.0)
        productCell.productPrice.text =  price
        //productCell.productSubTitle.text = product.vendor
        productCell.currencyTxt.text = viewModel?.getCurrencyType()
        
        productCell.presentAlertDeletion = {
            alert in
            self.present(alert, animated: true)
        }
                let Title = product.title
                var extractedTitle = Title

                if let firstRange = Title?.range(of: "|") {
                    extractedTitle = String((Title?[firstRange.upperBound...])!).trimmingCharacters(in: .whitespacesAndNewlines)
                    
                   
                    if let secondRange = extractedTitle?.range(of: "|") {
                        extractedTitle = String((extractedTitle?[..<secondRange.lowerBound])!).trimmingCharacters(in: .whitespacesAndNewlines)
                    }
                }
                let subTitle = product.handle
                var extractedsubTitle: String?

                if let firstRange = subTitle?.range(of: "-") {
                    extractedsubTitle = String(subTitle?[firstRange.upperBound...] ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
                }

                if let title = extractedsubTitle, title.count > 18 {
                    extractedsubTitle = String(title.prefix(18))
                }

                productCell.productTitle.text = extractedTitle

                productCell.productTitle.text = extractedTitle
        productCell.productSubTitle.text = product.vendor
              //  productCell.currencyTxt.text = viewModel?.getCurrencyType()
        
        if let imageUrl = product.image?.src {
            productCell.productImage.kf.setImage(with: URL(string: imageUrl))
        }

        let isFavorite = viewModel?.isProductInFavorites(productId: product.id ?? 0) ?? false
        let favImage = isFavorite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        productCell.favButton.setImage(favImage, for: .normal)
        
        let productDetailsViewModel = ProductDetailsViewModel(selectedProduct: product)
        let favProductsViewModel = viewModel?.getFavViewModel()
        productDetailsViewModel.setFavViewModel(favouriteProductsViewModel: favProductsViewModel ?? FavouriteProductsViewModel())
        
        productCell.configure(with: productDetailsViewModel)

        return productCell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let products = viewModel?.getProductsOfBrands() {
            let selectedProduct = products[indexPath.row]
            let productDetailsViewModel = ProductDetailsViewModel(selectedProduct: selectedProduct)
             
            let storyboard = UIStoryboard(name: "Part3", bundle: nil)
            if let productDetailsVC = storyboard.instantiateViewController(withIdentifier: "productDetailsScreen") as? ProductDetailsViewController {
                productDetailsVC.viewModel = productDetailsViewModel
                productDetailsVC.favViewModel = viewModel?.getFavViewModel()
                navigationController?.pushViewController(productDetailsVC, animated: true)
            }
        }
    }

    func productsSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .absolute(250))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 25)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(250))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15)
        section.interGroupSpacing = 10
        
        return section
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

