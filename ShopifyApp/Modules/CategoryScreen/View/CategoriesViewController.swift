//
//  CategoriesViewController.swift
//  ShopifyApp
//
//  Created by Aya Mostafa on 04/06/2024.
//

import UIKit
import DropDown
import Reachability

class CategoriesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    let reachability = try! Reachability()
    @IBOutlet weak var filterPrice: UIButton!
    var viewModel : HomeViewModelProtocol?
    var categoryId : Int?
    var priceRange : Int = 0
    var isFiltered : Bool?
    @IBOutlet weak var filterView: UIView!
    var filteredProducts: [Product] = []
    var filteredPriceProducts: [Product] = []
    let menuPrice: DropDown = {
        let menu = DropDown()
        menu.cornerRadius = 5
        //menu.animationEntranceOptions
        menu.scalesLargeContentImage = (UIImage(named: "priceicon.svg") != nil)
        menu.dataSource = [
            "All Prices",
            "Under EGP 100",
            "EGP 100 - EGP 200",
            "EGP 200 - EGP 300",
        ]
        
        return menu
    }()
    
    @IBOutlet weak var subCategoriesSeg: UISegmentedControl!
    @IBOutlet weak var saleBtn: UIButton!
    @IBOutlet weak var kidBtn: UIButton!
    @IBOutlet weak var menBtn: UIButton!
    @IBOutlet weak var womenBtn: UIButton!
    @IBOutlet weak var categoriesCollection: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = HomeViewModel()
        menuPrice.anchorView = filterView
        menuPrice.selectedTextColor = .orange
        self.filterProductsOfCategories()
        categoriesCollection.reloadData()
        let url = Constants.EndPoint.categories
        womenBtn.tintColor = .orange
        categoriesCollection.dataSource = self
        categoriesCollection.delegate = self
        let nib = UINib(nibName: "ProducCollectionViewCell", bundle: nil)
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
        
        //access the price menu
        
        menuPrice.selectionAction = { [weak self] index, title in
            print("the index = \(index) and title = \(title)")
            self?.priceRange = index
            self?.filterProductsByPrice()
        }
        
        viewModel?.bindToCategoriesViewController = { [weak self] in
        
            DispatchQueue.main.async {
                self?.subCategoriesSeg.selectedSegmentIndex = 0
                self?.loadCategoryProducts(categoryName: "women")
         
            }
        }
        viewModel?.fetchCategories(url: url)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        categoriesCollection.reloadData()
        handleNavigationBar()
    }
    
    func handleNavigationBar() {
        guard let view = self.navigationController?.visibleViewController else {
            return
        }
        
        let searchButton = UIBarButtonItem(image: UIImage(named: "searcc.svg"), style: .plain, target: self, action: #selector(searchButton))
        let cartButton = UIBarButtonItem(image: UIImage(systemName: "cart"), style: .plain, target: self, action: #selector(cartBtn))
        let heartButton = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(heartBtn))
        
        searchButton.tintColor = UIColor(ciColor: .black)
        cartButton.tintColor = UIColor(ciColor: .black)
        heartButton.tintColor = UIColor(ciColor: .black)
        
        view.navigationItem.leftBarButtonItem = searchButton
        view.navigationItem.rightBarButtonItems = [heartButton, cartButton]
    }
    
    
    @objc func addTapped(){
        
        print("perform")
    }
    
    @objc func cartBtn(){
        
        if viewModel?.checkIfUserAvaliable() == true {
            
            switch reachability.connection {
                
                case .unavailable:
                    let alert = UIAlertController(title: "network", message: "You are not connected to the network check you internet  ", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                
                    present(alert, animated: true)
                
                case .wifi , .cellular:
                    let shopingScreen = UIStoryboard(name: "Part2", bundle: nil).instantiateViewController(withIdentifier: "shoping-cart") as! ShoppingCartViewController
                    navigationController?.pushViewController(shopingScreen, animated: true)
                
            }
            
        }
        else {
            
            let alert = UIAlertController(title: "Guest", message: "You are not a user please login or reguster first ", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            
            present(alert, animated: true)
        }
        
        
    }
    
    @objc func heartBtn(){
        let storyboard = UIStoryboard(name: "Part3", bundle: nil)
        if let favProductsVC = storyboard.instantiateViewController(withIdentifier: "favProductsScreen") as? FavProductsViewController {
            navigationController?.pushViewController(favProductsVC, animated: true)
        }
        
        print("perform")
    }
    
    @objc func searchButton() {
        print("Search button tapped")
        print("Navigation controller: \(navigationController)")
        let storyboard = UIStoryboard(name: "Part3", bundle: nil)
        if let searchProductsVC = storyboard.instantiateViewController(withIdentifier: "searchProductsScreen") as? SearchViewController {
            print("Before navigation push")
            searchProductsVC.initialFilteredProducts = self.filteredProducts
            searchProductsVC.destination = true
            navigationController?.pushViewController(searchProductsVC, animated: true)
        } else {
            print("Failed to instantiate SearchViewController from storyboard")
        }
        print("After navigation logic")
    }


    
    
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredPriceProducts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let productCell = categoriesCollection.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! ProducCollectionViewCell
        productCell.productImage.layer.cornerRadius = 20
        // let product = filteredProducts[indexPath.row]
       // let product = filterProductsByPrice()[indexPath.row]
        //filterProductsByPrice()
        
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
        
        productCell.presentAlertDeletion = {
            alert in
            self.present(alert, animated: true)
        }
    
        let product = filteredPriceProducts[indexPath.row]
        productCell.productTitle.text = product.vendor
        let price = Double(product.variants?[0].price ?? "") ?? 0.0
        productCell.productPrice.text = CurrencyService.instance.calcThePrice(price: price)
        productCell.currencyTxt.text = CurrencyService.instance.getCurrencyType()
        productCell.productSubTitle.text = product.handle
        let productIMG = product.image?.src
        let imageUrl = URL(string: productIMG ?? "" )
        productCell.productImage.kf.setImage(with: imageUrl)
        
        let isFavorite = viewModel?.isProductInFavorites(productId: product.id ?? 0) ?? false
        let favImage = isFavorite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        productCell.favButton.setImage(favImage, for: .normal)
        
        // Set the viewModel for the cell
        let productDetailsViewModel = ProductDetailsViewModel(selectedProduct: product)
        let favProductsViewModel = viewModel?.getFavViewModel()
        productDetailsViewModel.setFavViewModel(favouriteProductsViewModel: favProductsViewModel ?? FavouriteProductsViewModel())
        
        productCell.configure(with: productDetailsViewModel)

        return productCell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let products = viewModel?.getProductsOfBrands() {
            let selectedProduct = products[indexPath.row]
            print("ccccccc\(selectedProduct.id)")
            let productDetailsViewModel = ProductDetailsViewModel(selectedProduct: selectedProduct)
             
            let storyboard = UIStoryboard(name: "Part3", bundle: nil)
            if let productDetailsVC = storyboard.instantiateViewController(withIdentifier: "productDetailsScreen") as? ProductDetailsViewController {
                productDetailsVC.viewModel = productDetailsViewModel
                productDetailsVC.favViewModel = viewModel?.getFavViewModel()
                navigationController?.pushViewController(productDetailsVC, animated: true)
            }
        }
    }
    
    @IBAction func womenAction(_ sender: Any) {
        loadCategoryProducts(categoryName: "women")
        categoriesCollection.reloadData()
        womenBtn.tintColor = .orange
        menBtn.tintColor = .black
        saleBtn.tintColor = .black
        kidBtn.tintColor = .black

    }
    
    @IBAction func menAction(_ sender: Any) {
        loadCategoryProducts(categoryName: "men")
        categoriesCollection.reloadData()
        womenBtn.tintColor = .black
        menBtn.tintColor = .orange
        saleBtn.tintColor = .black
        kidBtn.tintColor = .black
    }
    
    @IBAction func kidAction(_ sender: Any) {
        loadCategoryProducts(categoryName: "kid")
        categoriesCollection.reloadData()
        womenBtn.tintColor = .black
        menBtn.tintColor = .black
        saleBtn.tintColor = .black
        kidBtn.tintColor = .orange
    }
    @IBAction func saleAction(_ sender: Any) {
        loadCategoryProducts(categoryName: "sale")
        categoriesCollection.reloadData()
        womenBtn.tintColor = .black
        menBtn.tintColor = .black
        saleBtn.tintColor = .orange
        kidBtn.tintColor = .black
    }
    
    
    @IBAction func subCategoryAction(_ sender: Any) {
        filterProductsOfCategories()
        filterProductsByPrice()
        categoriesCollection.reloadData()
    }
    
    @IBAction func filterBtn(_ sender: Any) {
        categoriesCollection.reloadData()
        self.isFiltered = true
        menuPrice.show()
        categoriesCollection.reloadData()
    }
    
    
    private func loadCategoryProducts(categoryName: String) {
        guard let categoryId = viewModel?.getCategoryID(categoryName: categoryName) else {
            print("Invalid category ID")
            return
        }
        self.categoryId = categoryId
        self.filterProductsOfCategories()
        let productUrl = "/admin/api/2024-04/products.json?collection_id=\(categoryId)"
        viewModel?.bindToProductViewController = { [weak self] in
            DispatchQueue.main.async {
                self?.filterProductsOfCategories()
                self?.filterProductsByPrice()
                self?.categoriesCollection.reloadData()
            }
        }
        categoriesCollection.reloadData()
        viewModel?.fetchProducts(url: productUrl)
    }
    
    
    private func filterProductsOfCategories() {
        guard let products = viewModel?.getProductsOfBrands() else {
            return
        }
        switch subCategoriesSeg.selectedSegmentIndex {
        case 0:
            filteredProducts = products.filter{$0.productType == .shoes}
        case 1:
            filteredProducts = products.filter{$0.productType == .tShirts}
        case 2:
            filteredProducts = products.filter{$0.productType == .accessories}
        default:
            filteredProducts = products
        }
        categoriesCollection.reloadData()
    }
    
    private func filterProductsByPrice ()   {
        switch priceRange {
        case 0:
            filteredPriceProducts = filteredProducts
        case 1:
            filteredPriceProducts = filteredProducts.filter {
                if let priceString = $0.variants?[0].price, let price = Double(priceString) {
                            return price < 100
                        }
                        return false
                    }
        case 2:
            filteredPriceProducts = filteredProducts.filter {
                if let priceString = $0.variants?[0].price, let price = Double(priceString) {
                      return price >= 100 && price < 200
                  }
                  return false
              }
        case 3:
            filteredPriceProducts = filteredProducts.filter {
                if let priceString = $0.variants?[0].price, let price = Double(priceString) {
                      return price >= 200 && price < 300
                  }
                  return false
              }
        default:
            filteredPriceProducts = filteredProducts
            
        }
        categoriesCollection.reloadData()
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
    


}
