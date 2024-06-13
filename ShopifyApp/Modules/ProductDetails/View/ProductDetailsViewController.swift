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
    
    private var showMoreReviews = false
    private var reviews: [Review] = []
    var viewModel: ProductDetailsViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        productPrice.text = product.variants?.first?.price
        productDescription.text = product.bodyHtml
        productspageControl.numberOfPages = product.images?.count ?? 0
        productCollectionView.reloadData()
        sizeCollectionView.reloadData()
        colorsCollectionView.reloadData()
        reviewsCollectionView.reloadData()
    }



    private func createSizeCollectionViewLayout() -> UICollectionViewLayout {
        // Item size
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(50), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Group size
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(50), heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        
        // Spacing between items
        section.interGroupSpacing = 10 // Adjust the spacing between items as needed
        
  
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
 
