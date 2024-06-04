//
//  HomeViewModel.swift
//  ShopifyApp
//
//  Created by Aya Mostafa on 04/06/2024.
//

import Foundation

protocol HomeViewModelProtocol {
    var bindToHomeViewController: (() -> Void)? { get set }
    var bindToProductViewController: (() -> Void)? { get set }
    var bindToCategoriesViewController: (() -> Void)? { get set }
    func fetchBands (url : String)
    func fetchProducts (url : String)
    func fetchCategories (url : String)
    func getBrands() -> [SmartCollection]
    func getCaegroies() -> [CustomCollection]
    func getProductsOfBrands() -> [Product]
    func getCategoryID (categoryName: String) -> Int
}
    
class HomeViewModel : HomeViewModelProtocol{

        var bindToProductViewController: (() -> Void)?
        private var brands : [SmartCollection]?
        var bindToHomeViewController: (() -> Void)?
        var bindToCategoriesViewController: (() -> Void)?
        private var productsOfBrands : [Product]?
        private var categories : [CustomCollection]?
        //  private var products :
        
        
        func fetchBands (url : String) {
            ApiServices.shared.fetchData(urlString: url){ (result: Result<Brands, Error>) in
                switch result {
                case .success(let data):
                    print("update")
                    print("update2")
                    self.brands = data.smartCollections
                    self.bindToHomeViewController?()
                    print("the count of brands is \(data.smartCollections.count)")
                case .failure(let error):
                    print("failed to fetch brands with error \(error.localizedDescription)")
                }
            }
        }
        
        func fetchProducts (url : String) {
            ApiServices.shared.fetchData(urlString: url){ (result: Result<Products, Error>) in
                switch result {
                case .success(let data):
                    self.productsOfBrands = data.products
                    self.bindToProductViewController?()
                    print("the count of products is \(data.products.count)")
                case .failure(let error):
                    print("failed to fetch products with error \(error.localizedDescription)")
                }
            }
        }
        
        func fetchCategories (url : String) {
            ApiServices.shared.fetchData(urlString: url){ (result: Result<Categories, Error>) in
                switch result {
                case .success(let data):
                    self.categories = data.customCollections
                    self.bindToCategoriesViewController?()
                    print("the count of categories is \(data.customCollections.count)")
                case .failure(let error):
                    print("failed to fetch products with error \(error.localizedDescription)")
                }
            }
        }
        
        
    func getBrands() -> [SmartCollection] {
            guard let brands = brands else {
                return []
            }
            return brands
    }
        
    func getProductsOfBrands() -> [Product] {
            guard let products = productsOfBrands else {
                return []
            }
            return products
    }
    
    func getCaegroies() -> [CustomCollection] {
        guard let categories = categories else {
            return []
        }
        return categories
    }
    
    func getCategoryID (categoryName: String) -> Int{
    
        var categoryID : Int?
        for category in categories! {
            if(category.title == categoryName.lowercased()) {
                categoryID = category.id
            }
        }
        return categoryID ?? 0
    }
    
        
}

