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
    
    let completeUrl = "https://api.currencyapi.com/v3/latest?apikey=cur_live_3CT1Z4mcgwuAttoz2AcCPsmuE7Sp99FttZFv5J1S&base_currency=EGP&currencies[]=USD"
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
    
}
