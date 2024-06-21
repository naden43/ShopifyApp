//
//  Constants.swift
//  ShopifyApp
//
//  Created by Aya Mostafa on 04/06/2024.
//

import Foundation

struct Constants {
    static let baseUrl = "https://76854ee270534b0f6fe7e7283f53b057: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@mad44-sv-team4.myshopify.com"
    
    struct EndPoint {
        static let brands = "admin/api/2024-04/smart_collections.json"
        static let categories = "admin/api/2024-04/custom_collections.json"
        static let Placeorders = "admin/api/2024-04/orders.json"
        static let orders = "admin/api/2024-04/orders.json?status=any"
    }
}
