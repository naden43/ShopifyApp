//
//  ShopingCartModel.swift
//  ShopifyApp
//
//  Created by Naden on 07/06/2024.
//

import Foundation

struct TaxLine: Codable {
    let rate: Float?
    let title: String?
    let price: String?
}

struct DraftOrderLineItem: Codable {
    let id: Int?
    let variant_id: Int?
    let title: String?
    var quantity: Int?
    let taxable: Bool?
    let fulfillmentService: String?
    let taxLines: [TaxLine]?
    let price: String?
    let vendor:String?
    var properties:[[String : String]]

    private enum CodingKeys: String, CodingKey {
        case id ,vendor , variant_id
        case title
        case quantity
        case taxable
        case fulfillmentService = "fulfillment_service"
        case taxLines = "tax_lines"
        case price , properties
    }
}

struct Customer: Codable {
    let id: Int?
    let email: String?
    let createdAt: String?
    let updatedAt: String?
    let firstName: String?
    let lastName: String?
    let ordersCount: Int?
    let state: String?
    let totalSpent: String?
    let note: String?
    let verifiedEmail: Bool?
    let tags: String?
    let currency: String?
    let phone: String?

    private enum CodingKeys: String, CodingKey {
        case id
        case email
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case firstName = "first_name"
        case lastName = "last_name"
        case ordersCount = "orders_count"
        case state
        case totalSpent = "total_spent"
        case note
        case verifiedEmail = "verified_email"
        case tags
        case currency
        case phone
    }
}

struct DraftOrder: Codable {
    let id: Int?
    let note: String?
    let email: String?
    let taxesIncluded: Bool?
    let currency: String?
    let createdAt: String?
    let updatedAt: String?
    let taxExempt: Bool?
    let completedAt: String?
    let name: String?
    let status: String?
    var lineItems: [DraftOrderLineItem]?
    let shippingAddress: String?
    let billingAddress: String?
    let invoiceUrl: String?
    let orderId: Int?
    let shippingLine: String?
    let taxLines: [TaxLine]?
    let tags: String?
    let noteAttributes: [String]?
    let totalPrice: String?
    let subtotalPrice: String?
    let totalTax: String?
    let paymentTerms: String?
    let adminGraphqlApiId: String?
    let customer: Customer?

    private enum CodingKeys: String, CodingKey {
        case id
        case note
        case email
        case taxesIncluded = "taxes_included"
        case currency
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case taxExempt = "tax_exempt"
        case completedAt = "completed_at"
        case name
        case status
        case lineItems = "line_items"
        case shippingAddress = "shipping_address"
        case billingAddress = "billing_address"
        case invoiceUrl = "invoice_url"
        case orderId = "order_id"
        case shippingLine = "shipping_line"
        case taxLines = "tax_lines"
        case tags
        case noteAttributes = "note_attributes"
        case totalPrice = "total_price"
        case subtotalPrice = "subtotal_price"
        case totalTax = "total_tax"
        case paymentTerms = "payment_terms"
        case adminGraphqlApiId = "admin_graphql_api_id"
        case customer
    }
}

struct Draft: Codable {
    var draft_order: DraftOrder?
}
