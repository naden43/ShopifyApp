//
//  ProductsViewController.swift
//  ShopifyApp
//
//  Created by Aya Mostafa on 02/06/2024.
//

import UIKit
import Kingfisher

class ProductsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var productCollection: UICollectionView!
    var brandId : Int?
    var brandName : String?
    var viewModel : HomeViewModelProtocol?
    var productDetailsViewModel: ProductDetailsViewModel?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("The Brand id = \(self.brandId ?? 301445349542)")
        let url =  "/admin/api/2024-04/products.json?collection_id=\(self.brandId ?? 0)"
        viewModel = HomeViewModel()
        productCollection.dataSource = self
        productCollection.delegate = self
        let nib = UINib(nibName: "ProducCollectionViewCell", bundle: nil)
        productCollection.register(nib, forCellWithReuseIdentifier: "productCell")
        
        
        //Compositional layout
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            switch sectionIndex {
            case 0:
                return self.productsSectionLayout()
            default:
                return nil
            }
        }
        productCollection.collectionViewLayout = layout
        
        
        viewModel?.bindToProductViewController = {[weak self] in
                print("inside the bind closure of products")
                DispatchQueue.main.async {
                    self?.productCollection.reloadData()
                    print("the number of products in this brand is : \(self?.viewModel?.getProductsOfBrands().count ?? 0)")
                }
        }
        viewModel?.fetchProducts(url: url)
        // Do any additional setup after loading the view.
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
        var products = viewModel?.getProductsOfBrands()
        productCell.productTitle.text = products?[indexPath.row].vendor
        productCell.productPrice.text = products?[indexPath.row].variants?[0].price
        productCell.productSubTitle.text = products?[indexPath.row].handle
        print("the products is =========================================: \(products?[indexPath.row].title ?? "unkown product")")
        var productIMG = products?[indexPath.row].image?.src
        let imageUrl = URL(string: productIMG ?? "")
        productCell.productImage.kf.setImage(with: imageUrl)
        return productCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         if let products = viewModel?.getProductsOfBrands() {
             let selectedProduct = products[indexPath.row]
             let productDetailsViewModel = ProductDetailsViewModel(selectedProduct: selectedProduct)
             
             let storyboard = UIStoryboard(name: "Part3", bundle: nil)
             if let productDetailsVC = storyboard.instantiateViewController(withIdentifier: "productDetailsScreen") as? ProductDetailsViewController {
                 productDetailsVC.viewModel = productDetailsViewModel
                 navigationController?.pushViewController(productDetailsVC, animated: true)
             }
         }
     }
    func productsSectionLayout() -> NSCollectionLayoutSection {
        // Define the size of each item (movie cell)
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), // Each item takes up half of the width
                                              heightDimension: .absolute(250)) // Keep the height as 250 points

        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 25) // Add spacing between items
        
        // Create a group that contains two items horizontally
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), // The group takes up the full width of the section
                                               heightDimension: .absolute(250)) // Each group takes up the full height of the section
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item])
        
        // Center the group within the section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15)
        section.contentInsetsReference = .layoutMargins
        section.interGroupSpacing = 10 // Add spacing between rows
        
        return section
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
