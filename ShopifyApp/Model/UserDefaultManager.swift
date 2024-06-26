//
//  UserDefaultManager.swift
//  ShopifyApp
//
//  Created by Salma on 09/06/2024.
//


import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private let userDefualt = UserDefaults.standard
    
    private let customerIdKey = "customerId"
    private let favProductsDraftOrderIdKey = "favProductsDraftOrderId"
    private let shoppingCartDraftOrderIdKey = "shoppingCartDraftOrderId"
    private let currency = "currency"
    private let currencyValue = "currencyValue"
    private let guestMode = "guestMode"
    
    private init() {}
    
    
    func saveAsGuest() {
        UserDefaults.standard.set(true, forKey: guestMode)
    }
    
    func checkIfItGuestMode() -> Bool {
        
        let value = UserDefaults.standard.bool(forKey: guestMode)
        if value == true {
            return true
        }
        else {
            return false
        }
    }
    
    

    func saveCustomer(id: Int, note: String?) {
        UserDefaults.standard.set(id, forKey: customerIdKey)
        
        if let note = note {
            let noteParts = note.split(separator: ",")
            if noteParts.count == 2 {
                UserDefaults.standard.set(String(noteParts[0]), forKey: favProductsDraftOrderIdKey)
                UserDefaults.standard.set(String(noteParts[1]), forKey: shoppingCartDraftOrderIdKey)
            } else {
                UserDefaults.standard.set(nil, forKey: favProductsDraftOrderIdKey)
                UserDefaults.standard.set(nil, forKey: shoppingCartDraftOrderIdKey)
            }
        }
    }
    
    func saveCurrency(currencyType:String , value: Double){
        userDefualt.set(currencyType, forKey: currency)
        userDefualt.set(value, forKey: currencyValue)
    }
    
    func getTheCurrencyValue()->Double?{
        
        return userDefualt.value(forKey: currencyValue) as? Double
    }
    
    func getTheCurrencyType()->String?{
        
        return userDefualt.value(forKey: currency) as? String
    }
    

    func getCustomer() -> (id: Int?, favProductsDraftOrderId: String?, shoppingCartDraftOrderId: String?) {
        let id = UserDefaults.standard.integer(forKey: customerIdKey)
        let favProductsDraftOrderId = UserDefaults.standard.string(forKey: favProductsDraftOrderIdKey)
        let shoppingCartDraftOrderId = UserDefaults.standard.string(forKey: shoppingCartDraftOrderIdKey)
        return (id == 0 ? nil : id, favProductsDraftOrderId, shoppingCartDraftOrderId)
    }

    func clearCustomer() {
        UserDefaults.standard.removeObject(forKey: customerIdKey)
        UserDefaults.standard.removeObject(forKey: favProductsDraftOrderIdKey)
        UserDefaults.standard.removeObject(forKey: shoppingCartDraftOrderIdKey)
    }
}


