//
//  Categories.swift
//  ShopifyApp
//
//  Created by Aya Mostafa on 04/06/2024.
//

import Foundation

import Foundation

// MARK: - Welcome
struct Categories: Codable {
    let customCollections: [CustomCollection]

    enum CodingKeys: String, CodingKey {
        case customCollections = "custom_collections"
    }
}

// MARK: - CustomCollection
struct CustomCollection: Codable {
    let id: Int
    let handle, title: String
    //let updatedAt: Date
    let bodyHTML: String?
    //let publishedAt: Date
    let sortOrder: String
    let templateSuffix: JSONNull?
    let publishedScope, adminGraphqlAPIID: String
    let image: Image?

    enum CodingKeys: String, CodingKey {
        case id, handle, title
      //  case updatedAt = "updated_at"
        case bodyHTML = "body_html"
      //  case publishedAt = "published_at"
        case sortOrder = "sort_order"
        case templateSuffix = "template_suffix"
        case publishedScope = "published_scope"
        case adminGraphqlAPIID = "admin_graphql_api_id"
        case image
    }
    
    
    struct Image: Codable {
        //let createdAt: Date
        let alt: JSONNull?
        let width, height: Int
        let src: String

        enum CodingKeys: String, CodingKey {
           // case createdAt = "created_at"
            case alt, width, height, src
        }
    }

    
}
// MARK: - Encode/decode helpers

