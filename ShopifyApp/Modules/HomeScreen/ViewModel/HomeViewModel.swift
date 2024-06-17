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
            NetworkHandler.instance.getData(endPoint: url, complitionHandler: { (result:Brands? , error) in
                
                guard let result = result else {
                    return
                }
                self.brands = result.smartCollections
                self.bindToHomeViewController?()
            })
        }
        
        func fetchProducts (url : String) {
            NetworkHandler.instance.getData(endPoint: url, complitionHandler: { (result:Products? , error) in
                guard let result = result else {
                    return
                }
                self.productsOfBrands = result.products
                self.bindToProductViewController?()
            })
        }
        
        func fetchCategories (url : String) {
            NetworkHandler.instance.getData(endPoint: url, complitionHandler: { (result:Categories? , error) in
                guard let result = result else {
                    return
                }
                self.categories = result.customCollections
                self.bindToCategoriesViewController?()
            })
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
            if(category.handle.lowercased() == categoryName.lowercased()) {
                categoryID = category.id
                print("the category id for this category \(categoryName) = \(categoryID)")
            }
        }
        return categoryID ?? 0
    }
    
        
}

