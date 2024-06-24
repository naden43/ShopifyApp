//
//  ProfileViewModel.swift
//  ShopifyApp
//
//  Created by Naden on 18/06/2024.
//

import Foundation

class ProfileViewModel {
    
    let userDefualtManager = UserDefaultsManager.shared
    let network = NetworkHandler.instance
    var bindToOdersViewController: (() -> Void)?
    private var orders : [Order]?
    
    var bindFavourites : (()->Void) = {}
    var bindCustomerName : ((_ name : String)->Void)  = {_ in}
    
    var favProducts : DraftOrder?
    func checkIfUserAvaliable() -> Bool {
        
        print(userDefualtManager.getCustomer())
        if userDefualtManager.getCustomer().id != nil {
            return true
        }
        else {
            return false
        }
    }
    
    func fetchFavourites() {
        
        print("fetch fav")
        let favDraftOrder = UserDefaultsManager.shared.getCustomer().favProductsDraftOrderId!
        NetworkHandler.instance.getData(endPoint: "admin/api/2024-04/draft_orders/\(favDraftOrder).json") { (result: Draft?, error) in
            
            print(result)
            guard let result = result else {
                print(result)
                return
            }
            self.favProducts = result.draft_order
            self.bindFavourites()
        }
        
    }
    
    func getFavProductByIndex(index:Int) -> LineItem {
        
        let product = favProducts?.lineItems?[index+1]
        print(product)
        return product!
    }
    
    func getFavCount() -> Int {
        
        let counter = favProducts?.lineItems?.count ?? 0
        if  counter >= 3 {
            return 2
        }
        else if counter == 2{
            return 1
        }
        else {
            return 0
        }
    }
    
    func getImageByIndex(index: Int) -> String? {
        return favProducts?.lineItems?[index + 1].properties?.first?["value"]
    }
    
    func fetchOrders (url : String) {
        NetworkHandler.instance.getData(endPoint: url, complitionHandler: { (result:Orders? , error) in
            guard let result = result else {
                return
            }
            self.orders = result.orders
            self.bindToOdersViewController?()
        })
    }
    
    func getOrders() -> [Order] {
        guard let allOrders = orders else {
            return []
        }
        // Filter orders based on customerID
        let ordersForCustomer = allOrders.filter { $0.customer?.id == userDefualtManager.getCustomer().id }
        print("the customer id == \(userDefualtManager.getCustomer().id), and the number of order = \(ordersForCustomer.count)")
        return ordersForCustomer
    }
    
    func fetchCustomer() {
        
        let customerId = UserDefaultsManager.shared.getCustomer().id!
        NetworkHandler.instance.getData(endPoint: "admin/api/2024-04/customers/\(customerId).json") { [weak self]  ( customer : PostedCustomerResponse?, error) in
            
            if let customer = customer {
                self?.bindCustomerName(customer.customer.firstName ?? "User")
            }
            else {
                print(error)
            }
            
        }
        
    }
    
    func convertPriceByCurrency(price : Double) -> String {
        
        
        return CurrencyService.instance.calcThePrice(price: price)
    }
    
    func getCurrencyType() -> String {
        
        return CurrencyService.instance.getCurrencyType()
    }

    
}
