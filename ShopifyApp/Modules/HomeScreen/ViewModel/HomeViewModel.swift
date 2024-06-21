//
//  HomeViewModel.swift
//  ShopifyApp
//
//  Created by Aya Mostafa on 04/06/2024.
//

import Foundation

protocol HomeViewModelProtocol {
    func checkIfUserAvaliable() -> Bool
    var bindToHomeViewController: (() -> Void)? { get set }
    var bindToProductViewController: (() -> Void)? { get set }
    var bindToCategoriesViewController: (() -> Void)? { get set }
    var bindPriceRules : (() -> Void)? { get set }
    func fetchBands (url : String)
    func fetchProducts (url : String)
    func fetchCategories (url : String)
    func getBrands() -> [SmartCollection]
    func getCaegroies() -> [CustomCollection]
    func getProductsOfBrands() -> [Product]
    func getCategoryID (categoryName: String) -> Int
    func convertPriceByCurrency(price : Double) -> String 
    func getCurrencyType() -> String 
    func getPriceRuleByIndex(index:Int) ->String
    func getPriceRules()
    func getPriceRulesCount() -> Int
    func fetchCurrencyDataAndStore(currencyType:String)
    func isProductInFavorites(productId: Int) -> Bool
    func getFavViewModel() -> FavouriteProductsViewModel
    
}
    
class HomeViewModel : HomeViewModelProtocol{
   
    
        var bindPriceRules: (() -> Void)?
        var bindToProductViewController: (() -> Void)?
        private var brands : [SmartCollection]?
        var bindToHomeViewController: (() -> Void)?
        var bindToCategoriesViewController: (() -> Void)?
        private var productsOfBrands : [Product]?
        private var categories : [CustomCollection]?
        var favouriteProductsViewModel = FavouriteProductsViewModel()
    
      init() {
        favouriteProductsViewModel.loadData { [weak self] in
            self?.bindToProductViewController?()
        }
      }
    func getFavViewModel() -> FavouriteProductsViewModel{
        return favouriteProductsViewModel
    }

    
        private var coupons : [String] = []
        //  private var products :
        
    
        func getPriceRulesCount() -> Int {
            return coupons.count
        }
    
        func getPriceRules() {
            
            NetworkHandler.instance.getData(endPoint: "/admin/api/2024-04/price_rules.json") { [weak self ] (result:PriceRules? , error) in
                
                if let result = result {
                    
                    for item in result.price_rules {
                        self?.coupons.append(String(item.id))
                    }
                    
                }
                else {
                    print(error ?? "")
                }
            }
        
        }
        
        func getPriceRuleByIndex(index:Int) ->String {
            return coupons[index]
        }
    
        func checkIfUserAvaliable() -> Bool {
        
            if UserDefaultsManager.shared.getCustomer().id != nil {
                return true
            }
            else {
                return false
            }
        
        }
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
        
    func fetchCurrencyDataAndStore(currencyType:String){
        CurrencyService.instance.getData { (result:Currency?, error) in
            
            if let result = result {
                
                UserDefaultsManager.shared.saveCurrency(currencyType: currencyType, value: result.data.USD.value)
            }
            else {
                print("error")
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
    
    func convertPriceByCurrency(price : Double) -> String {
        
        
        return CurrencyService.instance.calcThePrice(price: price)
    }
    
    func getCurrencyType() -> String {
        
        return CurrencyService.instance.getCurrencyType()
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
              //  print("the category id for this category \(categoryName) = \(categoryID)")
            }
        }
        return categoryID ?? 0
    }
    
    func isProductInFavorites(productId: Int) -> Bool {
        return favouriteProductsViewModel.isProductInFavorites(productId: productId)
    }
    
        
}

