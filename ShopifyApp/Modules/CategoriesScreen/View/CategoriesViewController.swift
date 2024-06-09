//
//  CategoriesViewController.swift
//  ShopifyApp
//
//  Created by Aya Mostafa on 04/06/2024.
//

import UIKit

class CategoriesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{

    var viewModel : HomeViewModelProtocol?
    var categoryId : Int?
    @IBOutlet weak var subCategoriesSeg: UISegmentedControl!
    @IBOutlet weak var saleBtn: UIButton!
    @IBOutlet weak var kidBtn: UIButton!
    @IBOutlet weak var menBtn: UIButton!
    @IBOutlet weak var womenBtn: UIButton!
    @IBOutlet weak var categoriesCollection: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = HomeViewModel()
        let url = Constants.baseUrl + Constants.EndPoint.categories
        womenBtn.tintColor = .orange
        categoriesCollection.dataSource = self
        categoriesCollection.delegate = self
        let nib = UINib(nibName: "ProductCollectionViewCell", bundle: nil)
        categoriesCollection.register(nib, forCellWithReuseIdentifier: "productCell")
        
        
        //Compositional layout
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            switch sectionIndex {
            case 0:
                return self.productsSectionLayout()
            default:
                return nil
            }
        }
        categoriesCollection.collectionViewLayout = layout
        
        
        viewModel?.bindToCategoriesViewController = { [weak self] in
            print("inside the bind closure")
            DispatchQueue.main.async {
                self?.categoriesCollection.reloadData()
                self?.loadCategoryProducts(categoryName: "women")
                print("the count of categories is \(self?.viewModel?.getCaegroies().count ?? 0)")
                print("the name of categories is \(self!.saleBtn.titleLabel?.text ?? "")")
            }
        }
        viewModel?.fetchCategories(url: url)
       // loadCategoryProducts(categoryName: "women")
        // Do any additional setup after loading the view.
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.getProductsOfBrands().count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let productCell = categoriesCollection.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! ProductCollectionViewCell
        productCell.productImage.layer.cornerRadius = 20
        
        var products = viewModel?.getProductsOfBrands()
        productCell.productTitle.text = products?[indexPath.row].vendor
        productCell.productPrice.text = products?[indexPath.row].variants[0].price
        productCell.productSubtitle.text = products?[indexPath.row].handle
        var productIMG = products?[indexPath.row].image.src
        let imageUrl = URL(string: productIMG ?? "")
        productCell.productImage.kf.setImage(with: imageUrl)
        

        print("the sub category is === \(products?[0].productType ?? ProductType.accessories)")
        
        
        return productCell
        
    }
    
    @IBAction func womenAction(_ sender: Any) {
        loadCategoryProducts(categoryName: "women")
        womenBtn.tintColor = .orange
        menBtn.tintColor = .black
        saleBtn.tintColor = .black
        kidBtn.tintColor = .black

    }
    
    @IBAction func menAction(_ sender: Any) {
        loadCategoryProducts(categoryName: "men")
        womenBtn.tintColor = .black
        menBtn.tintColor = .orange
        saleBtn.tintColor = .black
        kidBtn.tintColor = .black
    }
    
    @IBAction func kidAction(_ sender: Any) {
        loadCategoryProducts(categoryName: "kid")
        womenBtn.tintColor = .black
        menBtn.tintColor = .black
        saleBtn.tintColor = .black
        kidBtn.tintColor = .orange
    }
    @IBAction func saleAction(_ sender: Any) {
        loadCategoryProducts(categoryName: "sale")
        womenBtn.tintColor = .black
        menBtn.tintColor = .black
        saleBtn.tintColor = .orange
        kidBtn.tintColor = .black
    }
    
    
    @IBAction func subCategoryAction(_ sender: Any) {
        
    }
    
    private func loadCategoryProducts(categoryName: String) {
        self.categoriesCollection.reloadData()
        categoryId = viewModel?.getCategoryID(categoryName: categoryName)
        guard let categoryId = categoryId else {
            print("Invalid category ID")
            return
        }
        print("the category id = \(categoryId)")
        //https://76854ee270534b0f6fe7e7283f53b057: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@mad44-sv-team4.myshopify.com//admin/api/2024-04/collections/301908230310/products.json
        let productUrl = Constants.baseUrl + "/admin/api/2024-04/products.json?collection_id=\(categoryId)"
        viewModel?.bindToProductViewController = { [weak self] in
            print("inside the bind closure of products")
            DispatchQueue.main.async {
                self?.categoriesCollection.reloadData()
                print("The number of products in this brand is: \(self?.viewModel?.getProductsOfBrands().count ?? 0)")
            }
        }
        viewModel?.fetchProducts(url: productUrl)
        self.categoriesCollection.reloadData()
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
    
    func filterTypeOfProduct () {
        
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
