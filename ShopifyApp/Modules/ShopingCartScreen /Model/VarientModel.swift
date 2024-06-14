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
    var id: Int64?
    var productId: Int64?
    var title: String?
    var price: String?
    var sku: String?
    var position: Int?
    var inventoryPolicy: String?
    var compareAtPrice: String?
    var fulfillmentService: String?
    var inventoryManagement: String?
    var option1: String?
    var option2: String?
    var option3: String?
    var createdAt: String?
    var updatedAt: String?
    var taxable: Bool?
    var barcode: String?
    var grams: Int?
    var weight: Double?
    var weightUnit: String?
    var inventoryItemId: Int?
    var inventoryQuantity: Int?
    var oldInventoryQuantity: Int?
    var requiresShipping: Bool?
    var adminGraphqlApiId: String?
    var imageId: String?
}

struct Option: Codable {
    var id: Int?
    var productId: Int?
    var name: String?
    var position: Int?
    var values: [String]?
}

struct Image: Codable {
    var id: Int?
    var alt: String?
    var position: Int?
    var productId: Int?
    var createdAt: String?
    var updatedAt: String?
    var adminGraphqlApiId: String?
    var width: Int?
    var height: Int?
    var src: String?
    var variantIds: [String]?
    
    enum CodingKeys: String, CodingKey {
        case id, alt, position, width, height, src
        case productId = "product_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case adminGraphqlApiId = "admin_graphql_api_id"
        case variantIds = "variant_ids"
    }
}


struct PresentmentPrice: Codable {
    var price: Price?
    var compare_at_price: String?
}

struct Price: Codable {
    var amount: String?
    var currency_code: String?
}
