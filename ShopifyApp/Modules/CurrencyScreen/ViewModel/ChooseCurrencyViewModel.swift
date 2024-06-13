//
//  ChooseCurrencyViewModel.swift
//  ShopifyApp
//
//  Created by Naden on 13/06/2024.
//

import Foundation

class ChooseCurrencyViewModel{
    
    private var userDefaultManager = UserDefaultsManager.shared
    
    
    func getTheSelectedCurrency() -> String?{
        
        return userDefaultManager.getTheCurrencyType()
    }
    
    
    func fetchCurrencyDataAndStore(currencyType:String){
        CurrencyService.instance.getData { (result:Currency?, error) in
            
            if let result = result {
                
                self.userDefaultManager.saveCurrency(currencyType: currencyType, value: result.data.USD.value)
            }
            else {
                print("error")
            }
            
        }
    }
    
}
