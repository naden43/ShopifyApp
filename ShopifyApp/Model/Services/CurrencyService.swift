//
//  CurrencyService.swift
//  ShopifyApp
//
//  Created by Naden on 13/06/2024.
//

import Foundation
import Alamofire

class CurrencyService {
    
    static let instance = CurrencyService()
    var userDefualtManager = UserDefaultsManager.shared

    let completeUrl = "https://api.currencyapi.com/v3/latest?apikey=cur_live_4hxPlUfXuMuRaavM5TrjLfbcFUg3qkTyrcrtqLUq&base_currency=EGP&currencies[]=USD"
    private init(){}
    
    
    
    func getData<T:Codable>(complitionHandler : @escaping (T? , String?)->Void ){
        
        guard  let url = URL(string: completeUrl) else {
            complitionHandler(nil , "")
            return
        }
        
   
        AF.request(url, method: .get)
            .validate()
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let value):
                    complitionHandler(value , "Success")
                case .failure(let error):
                    print(error)
                    complitionHandler(nil , "Faild")
                }
       }
        
        
        
    }
    
    func getCurrencyType()->String {
        
        if let currencyType = userDefualtManager.getTheCurrencyType() {
            return currencyType
        }
        else{
            return "EGP"
        }
    }
    
    
    func calcThePrice(price:Double) -> String
    {
        if let currencyType = userDefualtManager.getTheCurrencyType() {
            
            if let currencyValue = userDefualtManager.getTheCurrencyValue() {
                
                if currencyType == "EGP" {
                    
                    return String(price)
                }
                else {
                   return String(format: "%.3f", price * currencyValue)                }
            }
            else {
                return String(price)
            }
        }
        else{
            return String(price)
        }
    }
    
}
