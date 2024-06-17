//
//  CountryModel.swift
//  ShopifyApp
//
//  Created by Naden on 12/06/2024.
//

import Foundation

struct Countries : Codable{
    var countries:[Country]
}

struct Country : Codable {
    
    var name:String
    var cities:[String]
}
