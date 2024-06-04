//
//  CategoriesViewController.swift
//  ShopifyApp
//
//  Created by Aya Mostafa on 04/06/2024.
//

import UIKit

class CategoriesViewController: UIViewController{

    var viewModel : HomeViewModelProtocol?
    var categoryId : Int?
    @IBOutlet weak var saleBtn: UIButton!
    @IBOutlet weak var kidsBtn: UIButton!
    @IBOutlet weak var menBtn: UIButton!
    @IBOutlet weak var womenBtn: UIButton!
    @IBOutlet weak var categoriesCollection: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = HomeViewModel()
        let url = Constants.baseUrl + Constants.EndPoint.categories
        let productUrl = Constants.baseUrl + "/admin/api/2024-04/products.json?collection_id=\(0)"
//        categoriesCollection.dataSource = self
//        categoriesCollection.delegate = self
        let nib = UINib(nibName: "ProductCollectionViewCell", bundle: nil)
        categoriesCollection.register(nib, forCellWithReuseIdentifier: "productCell")
        viewModel?.bindToCategoriesViewController = { [weak self] in
            print("inside the bind closure")
            DispatchQueue.main.async {
                self?.categoriesCollection.reloadData()
                print("the count of categories is \(self?.viewModel?.getCaegroies().count ?? 0)")
                print("the name of categories is \(self!.saleBtn.titleLabel?.text)")
            }
        }
        viewModel?.fetchCategories(url: url)
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func womenAction(_ sender: Any) {
    }
    
    @IBAction func menAction(_ sender: Any) {
        
    }
    
    @IBAction func kidsAction(_ sender: Any) {
    }
    @IBAction func saleAction(_ sender: Any) {
    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
     
     
     categoryId = viewModel?.getCategoryID(categoryName: womenBtn.titleLabel?.text ?? "unkown")
     let productUrl = Constants.baseUrl + "/admin/api/2024-04/products.json?collection_id=\(0)"
     viewModel?.bindToProductViewController = {[weak self] in
          print("inside the bind closure of products")
          DispatchQueue.main.async {
              self?.categoriesCollection.reloadData()
              print("the number of products in this brand is : \(self?.viewModel?.getProductsOfBrands().count ?? 0)")
          }
    }
    viewModel?.fetchProducts(url: productUrl)
    }
    */

}
