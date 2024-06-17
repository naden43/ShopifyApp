//
//  Currency.swift
//  ShopifyApp
//
//  Created by Naden on 13/06/2024.
//

import Foundation

struct Currency : Codable{
    
    var data : CurrencyData
}

struct CurrencyData : Codable {
    
    var USD : CurrencyTarget
}

struct CurrencyTarget : Codable{
    
    var code:String
    var value:Double
    
}
