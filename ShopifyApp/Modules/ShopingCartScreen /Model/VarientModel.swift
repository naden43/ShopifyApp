//
//  File.swift
//  ShopifyApp
//
//  Created by Naden on 08/06/2024.
//


struct VarientData : Codable {
    
    var variant: Variant?
}


struct Variant: Codable {
    var id: Int?
    var product_id: Int?
    var title: String?
    var price: String?
    var sku: String?
    var position: Int?
    var inventory_policy: String?
    var compare_at_price: String?
    var fulfillment_service: String?
    var inventory_management: String?
    var option1: String?
    var option2: String?
    var option3: String?
    var created_at: String?
    var updated_at: String?
    var taxable: Bool?
    var barcode: String?
    var grams: Int?
    var weight: Double?
    var weight_unit: String?
    var inventory_item_id: Int?
    var inventory_quantity: Int?
    var old_inventory_quantity: Int?
    var presentment_prices: [PresentmentPrice]?
    var requires_shipping: Bool?
    var admin_graphql_api_id: String?
    var image_id: Int?
}


struct PresentmentPrice: Codable {
    var price: Price?
    var compare_at_price: String?
}

struct Price: Codable {
    var amount: String?
    var currency_code: String?
}
