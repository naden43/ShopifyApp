//
//  PriceRule.swift
//  ShopifyApp
//
//  Created by Naden on 15/06/2024.
//

import Foundation

struct PriceRule: Codable {
    let id: Int
    let value: String

    enum CodingKeys: String, CodingKey {
        case id
        case value
    }
}

struct PriceRuleData : Codable{
    let price_rule : PriceRule
}

struct PriceRules : Codable {
    
    let price_rules : [PriceRule]
}

