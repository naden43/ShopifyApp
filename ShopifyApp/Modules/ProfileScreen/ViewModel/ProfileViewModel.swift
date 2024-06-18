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
    
    
    func checkIfUserAvaliable() -> Bool {
        
        if userDefualtManager.getCustomer().id != nil {
            return true
        }
        else {
            return false
        }
        
    }
    
    
}
