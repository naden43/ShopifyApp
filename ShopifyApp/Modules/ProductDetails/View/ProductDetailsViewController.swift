//
//  ProductDetailsViewController.swift
//  ShopifyApp
//
//  Created by Salma on 11/06/2024.
//


import UIKit
import Cosmos

class ProductDetailsViewController: UIViewController {
    
    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productBrand: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productRate: UIView!
    var cosmosView: CosmosView!
    @IBOutlet weak var sizeCollectionView: UICollectionView!
    @IBOutlet weak var colorsCollectionView: UICollectionView!
    
    @IBOutlet weak var reviewsCollectionView: UICollectionView!
    @IBOutlet weak var productDescription: UITextView!
    @IBOutlet weak var productspageControl: UIPageControl!
    
    @IBOutlet weak var btnAddToFav: UIButton!
    
    private var showMoreReviews = false
    private var reviews: [Review] = []
    var viewModel: ProductDetailsViewModel?
    var favViewModel : FavouriteProductsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // print("Userid \(UserDefaultsManager.shared.getCustomer())")
        print(favViewModel?.favProducts?.lineItems)
        viewModel?.setFavViewModel(favouriteProductsViewModel: favViewModel ?? FavouriteProductsViewModel())

        
        productCollectionView.dataSource = self
        productCollectionView.delegate = self
        
        sizeCollectionView.dataSource = self
        sizeCollectionView.delegate = self
        
        colorsCollectionView.dataSource = self
        colorsCollectionView.delegate = self
        reviewsCollectionView.dataSource = self
        reviewsCollectionView.delegate = self
        productDescription.isScrollEnabled = false
        
        if let layout = productCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
        productCollectionView.showsHorizontalScrollIndicator = false
        productCollectionView.showsVerticalScrollIndicator = false
        
        sizeCollectionView.collectionViewLayout = createSizeCollectionViewLayout()
        colorsCollectionView.collectionViewLayout = createSizeCollectionViewLayout()
        
        updateUI()
        setupDummyReviews()
        setupCosmosView()
    }
    
    func setupCosmosView() {
        cosmosView = CosmosView()
        cosmosView.settings.fillMode = .half
        cosmosView.settings.starSize = 16
        cosmosView.settings.starMargin = 2
        cosmosView.settings.filledColor = .orange
        cosmosView.settings.emptyBorderColor = .orange
        cosmosView.settings.filledBorderColor = .orange
        cosmosView.rating = 3
        cosmosView.isUserInteractionEnabled = false
        
        productRate.addSubview(cosmosView)
        cosmosView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cosmosView.leadingAnchor.constraint(equalTo: productRate.leadingAnchor),
            cosmosView.trailingAnchor.constraint(equalTo: productRate.trailingAnchor),
            cosmosView.topAnchor.constraint(equalTo: productRate.topAnchor),
            cosmosView.bottomAnchor.constraint(equalTo: productRate.bottomAnchor)
        ])
    }
    
    private func updateUI() {
        guard let product = viewModel?.selectedProduct else { return }
        productTitle.text = product.title
        productBrand.text = "Brand: \(product.vendor ?? "Unknown")"
        let price = Double(product.variants?.first?.price ?? "") ?? 0.0
        productPrice.text = "\(viewModel?.convertPriceByCurrency(price: price) ?? "") \(viewModel?.getCurrencyType() ?? "")"
        productDescription.text = product.bodyHtml
        productspageControl.numberOfPages = product.images?.count ?? 0
        productCollectionView.reloadData()
        sizeCollectionView.reloadData()
        colorsCollectionView.reloadData()
        reviewsCollectionView.reloadData()
        
        // Check if product is in favorites
        print("viewModel?.isProductInFavorites()\(viewModel?.isProductInFavorites())")
        if viewModel?.isProductInFavorites() == true {
            print("true")
            btnAddToFav.setImage(UIImage(named: "filledHeart"), for: .normal)
        } else {
            print("false")
            btnAddToFav.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }

    
    private func createSizeCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(50), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(50), heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        section.interGroupSpacing = 10
        section.orthogonalScrollingBehavior = .continuous
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func setupDummyReviews() {
        let dummyImage = UIImage(named: "reviewer")
        reviews = [
            Review(personImage: dummyImage!, comment: "Great product!", rate: 4.5),
            Review(personImage: dummyImage!, comment: "Good value for money.", rate: 4.0),
            Review(personImage: dummyImage!, comment: "Satisfied with the purchase.", rate: 3.8),
            Review(personImage: dummyImage!, comment: "Excellent quality.", rate: 5.0),
            Review(personImage: dummyImage!, comment: "Not bad.", rate: 3.0),
            Review(personImage: dummyImage!, comment: "Could be better.", rate: 2.5)
        ]
        reviewsCollectionView.reloadData()
    }
    
    @IBAction func btnAddToCart(_ sender: Any) {
        viewModel?.destination = true
        guard let selectedSize = getSelectedSize(),
              let selectedColor = getSelectedColor() else {
            showAlert(message: "Please select both size and color before adding to cart.")
            return
        }
        
        viewModel?.addSelectedProductToDraftOrder { success, message in
            DispatchQueue.main.async {
                if success {
                    let alert = UIAlertController(title: "Success", message: "Product added to cart successfully.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                } else {
                    let alert = UIAlertController(title: "Error", message: message ?? "Failed to add product to cart.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
            }
        }
        viewModel?.destination = false
    }
    
    @IBAction func btnAddToFav(_ sender: Any) {
        guard let viewModel = viewModel else {
            return
        }
        
        
        let isInFavorites = viewModel.isProductInFavorites()
        
        if isInFavorites {
            viewModel.deleteProductFromDraftOrder(productId: viewModel.selectedProduct?.id ?? 0) { success in
                DispatchQueue.main.async {
                    if success {
                        if let emptyHeartImage = UIImage(systemName: "heart") {
                            if let button = sender as? UIButton {
                                button.setImage(emptyHeartImage, for: .normal)
                            }
                        }
                        let alert = UIAlertController(title: "Success", message: "Product removed from Favorites.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(alert, animated: true)
                    } else {
                        let alert = UIAlertController(title: "Error", message: "Failed to remove product from Favorites.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(alert, animated: true)
                    }
                }
            }
        } else {
            viewModel.addSelectedProductToDraftOrder { success, message in
                DispatchQueue.main.async {
                    if success {
                        // Update UI: Change button image to filled heart
                        if let filledHeartImage = UIImage(named: "filledHeart") {
                            if let button = sender as? UIButton {
                                button.setImage(filledHeartImage, for: .normal)
                            }
                        }
                        let alert = UIAlertController(title: "Success", message: "Product added to Favorites.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(alert, animated: true)
                    } else {
                        let alert = UIAlertController(title: "Error", message: message ?? "Failed to add product to Favorites.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(alert, animated: true)
                    }
                }
            }
        }
    }

    
    private func getSelectedSize() -> String? {
        guard let selectedIndex = sizeCollectionView.indexPathsForSelectedItems?.first?.item,
              let sizeValue = viewModel?.selectedProduct?.options?.first(where: { $0.name == "Size" })?.values?[selectedIndex] else {
            return nil
        }
        return sizeValue
    }

    private func getSelectedColor() -> String? {
        guard let selectedIndex = colorsCollectionView.indexPathsForSelectedItems?.first?.item,
              let colorValue = viewModel?.selectedProduct?.options?.first(where: { $0.name == "Color" })?.values?[selectedIndex] else {
            return nil
        }
        return colorValue
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

    


 extension ProductDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
     
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         if collectionView == productCollectionView {
             return viewModel?.selectedProduct?.images?.count ?? 0
         } else if collectionView == sizeCollectionView {
             return viewModel?.selectedProduct?.options?.first(where: { $0.name == "Size" })?.values?.count ?? 0
         } else if collectionView == colorsCollectionView {
             return viewModel?.selectedProduct?.options?.first(where: { $0.name == "Color" })?.values?.count ?? 0
         } else if collectionView == reviewsCollectionView {
             return showMoreReviews ? reviews.count : min(reviews.count, 2)
         }
         return 0
     }

     
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         if collectionView == productCollectionView {
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductImagesCollectionViewCell", for: indexPath) as! ProductImagesCollectionViewCell
             if let imageUrl = viewModel?.selectedProduct?.images?[indexPath.item].src {
                 cell.configure(with: imageUrl)
             }
             return cell
         } else if collectionView == sizeCollectionView {
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SizesCollectionViewCell", for: indexPath) as! SizesCollectionViewCell
             if let sizeValue = viewModel?.selectedProduct?.options?.first(where: { $0.name == "Size" })?.values?[indexPath.item] {
                 cell.productSize.text = sizeValue
             }
             return cell
         } else if collectionView == colorsCollectionView {
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorsCollectionViewCell", for: indexPath) as! ColorsCollectionViewCell
             if let value = viewModel?.selectedProduct?.options?.first(where: { $0.name == "Color" })?.values?[indexPath.item] {
                      cell.setColorForValue(value)
                  } else {
                      cell.setColorForValue(nil)                   }
             return cell
         } else if collectionView == reviewsCollectionView {
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReviewsCollectionViewCell", for: indexPath) as! ReviewsCollectionViewCell
             cell.configure(with: reviews[indexPath.item])
             return cell
         }
         return UICollectionViewCell()
     }
     
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         if collectionView == productCollectionView {
             return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
         } else if collectionView == sizeCollectionView || collectionView == colorsCollectionView {
             return CGSize(width: 50, height: collectionView.frame.height)
         } else if collectionView == reviewsCollectionView {
             return CGSize(width: collectionView.frame.width, height: 80)
         }
         return CGSize.zero
     }
     
         func scrollViewDidScroll(_ scrollView: UIScrollView) {
             if scrollView == productCollectionView {
                 let pageWidth = scrollView.frame.size.width
                 let currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
                 productspageControl.currentPage = currentPage
             }
         }
 }

