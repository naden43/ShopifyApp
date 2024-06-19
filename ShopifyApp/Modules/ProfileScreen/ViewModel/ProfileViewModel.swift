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
    
    func checkIfUserAvaliable() -> Bool {
        
        if userDefualtManager.getCustomer().id != nil {
            return true
        }
        else {
            return false
        }
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
    

    
}
