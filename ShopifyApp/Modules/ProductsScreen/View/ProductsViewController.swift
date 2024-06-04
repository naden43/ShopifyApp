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
    override func viewDidLoad() {
        super.viewDidLoad()
        print("The Brand id = \(self.brandId ?? 301445349542)")
        let url = Constants.baseUrl + "/admin/api/2024-04/products.json?collection_id=\(self.brandId ?? 0)"
        viewModel = HomeViewModel()
        productCollection.dataSource = self
        productCollection.delegate = self
        let nib = UINib(nibName: "ProductCollectionViewCell", bundle: nil)
        productCollection.register(nib, forCellWithReuseIdentifier: "productCell")
        
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
        let productCell = productCollection.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! ProductCollectionViewCell
        productCell.productImage.layer.cornerRadius = 20
        
        var products = viewModel?.getProductsOfBrands()
        productCell.productTitle.text = products?[indexPath.row].vendor
        productCell.productPrice.text = products?[indexPath.row].variants[0].price
        productCell.productSubtitle.text = products?[indexPath.row].handle
        print("the products is =========================================: \(products?[indexPath.row].title ?? "unkown product")")
        var productIMG = products?[indexPath.row].image.src
        let imageUrl = URL(string: productIMG ?? "")
        productCell.productImage.kf.setImage(with: imageUrl)
        return productCell
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
