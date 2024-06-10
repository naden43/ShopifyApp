//
//  DraftOrderData.swift
//  ShopifyApp
//
//  Created by Salma on 04/06/2024.
//


import Foundation

struct DraftOrders: Codable {
    let draftOrder: DraftOrder

    enum CodingKeys: String, CodingKey {
        case draftOrder = "draft_order"
    }
}
struct DraftOrder: Codable {
    var id: Int64?
    var note: String?
    var email: String?
    var taxesIncluded: Bool?
    var currency: String?
    var invoiceSentAt: String?
    var createdAt: String?
    var updatedAt: String?
    var taxExempt: Bool?
    var completedAt: String?
    var name: String?
    var status: String?
    var lineItems: [LineItem]?
    var shippingAddress: String?
    var billingAddress: String?
    var invoiceUrl: String?
    var appliedDiscount: String?
    var orderId: Int64?
    var shippingLine: String?
    var taxLines: [TaxLine]?
    var tags: String?
    var noteAttributes: [String]?
    var totalPrice: String?
    var subtotalPrice: String?
    var totalTax: String?
    var paymentTerms: String?
    var adminGraphqlApiId: String?
    var customer: Customer?

    enum CodingKeys: String, CodingKey {
        case id, note, email, currency, name, status, tags
        case taxesIncluded = "taxes_included"
        case invoiceSentAt = "invoice_sent_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case taxExempt = "tax_exempt"
        case completedAt = "completed_at"
        case lineItems = "line_items"
        case shippingAddress = "shipping_address"
        case billingAddress = "billing_address"
        case invoiceUrl = "invoice_url"
        case appliedDiscount = "applied_discount"
        case orderId = "order_id"
        case shippingLine = "shipping_line"
        case taxLines = "tax_lines"
        case noteAttributes = "note_attributes"
        case totalPrice = "total_price"
        case subtotalPrice = "subtotal_price"
        case totalTax = "total_tax"
        case paymentTerms = "payment_terms"
        case adminGraphqlApiId = "admin_graphql_api_id"
        case customer
    }
    
    init(id: Int64? = nil, note: String? = nil, email: String? = nil, taxesIncluded: Bool? = nil, currency: String? = nil,
         invoiceSentAt: String? = nil, createdAt: String? = nil, updatedAt: String? = nil, taxExempt: Bool? = nil,
         completedAt: String? = nil, name: String? = nil, status: String? = nil, lineItems: [LineItem]? = nil,
         shippingAddress: String? = nil, billingAddress: String? = nil, invoiceUrl: String? = nil, appliedDiscount: String? = nil,
         orderId: Int64? = nil, shippingLine: String? = nil, taxLines: [TaxLine]? = nil, tags: String? = nil,
         noteAttributes: [String]? = nil, totalPrice: String? = nil, subtotalPrice: String? = nil, totalTax: String? = nil,
         paymentTerms: String? = nil, adminGraphqlApiId: String? = nil, customer: Customer? = nil) {
        
        self.id = id
        self.note = note
        self.email = email
        self.taxesIncluded = taxesIncluded
        self.currency = currency
        self.invoiceSentAt = invoiceSentAt
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.taxExempt = taxExempt
        self.completedAt = completedAt
        self.name = name
        self.status = status
        self.lineItems = lineItems
        self.shippingAddress = shippingAddress
        self.billingAddress = billingAddress
        self.invoiceUrl = invoiceUrl
        self.appliedDiscount = appliedDiscount
        self.orderId = orderId
        self.shippingLine = shippingLine
        self.taxLines = taxLines
        self.tags = tags
        self.noteAttributes = noteAttributes
        self.totalPrice = totalPrice
        self.subtotalPrice = subtotalPrice
        self.totalTax = totalTax
        self.paymentTerms = paymentTerms
        self.adminGraphqlApiId = adminGraphqlApiId
        self.customer = customer
    }
}


struct LineItem: Codable {
    var id: Int64?
    var variantId: Int64?
    var productId: Int64?
    var title: String?
    var variantTitle: String?
    var sku: String?
    var vendor: String?
    var quantity: Int?
    var requiresShipping: Bool?
    var taxable: Bool?
    var giftCard: Bool?
    var fulfillmentService: String?
    var grams: Int?
    var taxLines: [TaxLine]?
    var appliedDiscount: String?
    var name: String?
    var properties: [[String:String]]?
    var custom: Bool?
    var price: String?
    var adminGraphqlApiId: String?

    enum CodingKeys: String, CodingKey {
        case id, title, sku, vendor, quantity, grams, name, properties, custom, price
        case variantId = "variant_id"
        case productId = "product_id"
        case variantTitle = "variant_title"
        case requiresShipping = "requires_shipping"
        case taxable
        case giftCard = "gift_card"
        case fulfillmentService = "fulfillment_service"
        case taxLines = "tax_lines"
        case appliedDiscount = "applied_discount"
        case adminGraphqlApiId = "admin_graphql_api_id"
    }
    
    init(id: Int64? = nil, variantId: Int64? = nil, productId: Int64? = nil, title: String? = nil,
         variantTitle: String? = nil, sku: String? = nil, vendor: String? = nil, quantity: Int? = nil,
         requiresShipping: Bool? = nil, taxable: Bool? = nil, giftCard: Bool? = nil, fulfillmentService: String? = nil,
         grams: Int? = nil, taxLines: [TaxLine]? = nil, appliedDiscount: String? = nil, name: String? = nil,
         properties: [[String:String]]? = nil, custom: Bool? = nil, price: String? = nil, adminGraphqlApiId: String? = nil) {
        
        self.id = id
        self.variantId = variantId
        self.productId = productId
        self.title = title
        self.variantTitle = variantTitle
        self.sku = sku
        self.vendor = vendor
        self.quantity = quantity
        self.requiresShipping = requiresShipping
        self.taxable = taxable
        self.giftCard = giftCard
        self.fulfillmentService = fulfillmentService
        self.grams = grams
        self.taxLines = taxLines
        self.appliedDiscount = appliedDiscount
        self.name = name
        self.properties = properties
        self.custom = custom
        self.price = price
        self.adminGraphqlApiId = adminGraphqlApiId
    }
}

struct TaxLine: Codable {
    let rate: Double
    let title: String
    let price: String
}
