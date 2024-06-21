//
//  Orders.swift
//  ShopifyApp
//
//  Created by Aya Mostafa on 18/06/2024.
//

import Foundation

// MARK: - Welcome
struct OrderRequest: Codable {
    let order: Order
}

struct Orders: Codable {
    let orders: [Order]
}


// MARK: - Order
struct Order: Codable {
    var id: Int?
       var adminGraphqlAPIID: String?
       var appID: Int?
       var browserIP: JSONNull?
       var buyerAcceptsMarketing: Bool?
       var cancelReason, cancelledAt, cartToken, checkoutID: JSONNull?
       var checkoutToken, clientDetails, closedAt, company: JSONNull?
       var confirmationNumber: String?
       var confirmed: Bool?
       var contactEmail: String?
       var createdAt: String? // Consider using Date type if createdAt is a date string
       var currency: Currency?
       var currentSubtotalPrice: String?
       //var currentSubtotalPriceSet: Set?
       var currentTotalAdditionalFeesSet: JSONNull?
       var currentTotalDiscounts: String?
       //var currentTotalDiscountsSet: Set?
       var currentTotalDutiesSet: JSONNull?
       var currentTotalPrice: String?
       //var currentTotalPriceSet: Set?
       var currentTotalTax: String?
       //var currentTotalTaxSet: Set?
       var customerLocale, deviceID: JSONNull?
       var discountCodes: [JSONAny]?
       var email: String?
       var estimatedTaxes: Bool?
       var financialStatus: FinancialStatus?
       var fulfillmentStatus, landingSite, landingSiteRef, locationID: JSONNull?
       var merchantOfRecordAppID: JSONNull?
       var name: String?
       var note: JSONNull?
       var noteAttributes: [JSONAny]?
       var number, orderNumber: Int?
       var orderStatusURL: String?
       var originalTotalAdditionalFeesSet, originalTotalDutiesSet: JSONNull?
       var paymentGatewayNames: [JSONAny]?
       var phone, poNumber: JSONNull?
       var presentmentCurrency: Currency?
       var processedAt: String? // Consider using Date type if processedAt is a date string
       var reference, referringSite, sourceIdentifier: JSONNull?
       var sourceName: String?
       var sourceURL: JSONNull?
       var subtotalPrice: String?
      // var subtotalPriceSet: Set?
       var tags: Tags?
       var taxExempt: Bool?
       var taxLines: [TaxLine]?
       var taxesIncluded, test: Bool?
       var token, totalDiscounts: String?
      // var totalDiscountsSet: Set?
       var totalLineItemsPrice: String?
      // var totalLineItemsPriceSet: Set?
       var totalOutstanding, totalPrice: String?
      // var totalPriceSet, totalShippingPriceSet: Set?
       var totalTax: String?
      // var totalTaxSet: Set?
       var totalTipReceived: String?
       var totalWeight: Int?
       var updatedAt: String? // Consider using Date type if updatedAt is a date string
       var userID: JSONNull?
       var billingAddress: Address?
       var customer: Customer?
       var discountApplications, fulfillments: [JSONAny]?
       var lineItems: [LineItem]?
       var paymentTerms: JSONNull?
       var refunds: [JSONAny]?
       var shippingAddress: Address?
       var shippingLines: [JSONAny]?

       enum CodingKeys: String, CodingKey {
           case id
           case adminGraphqlAPIID = "admin_graphql_api_id"
           case appID = "app_id"
           case browserIP = "browser_ip"
           case buyerAcceptsMarketing = "buyer_accepts_marketing"
           case cancelReason = "cancel_reason"
           case cancelledAt = "cancelled_at"
           case cartToken = "cart_token"
           case checkoutID = "checkout_id"
           case checkoutToken = "checkout_token"
           case clientDetails = "client_details"
           case closedAt = "closed_at"
           case company
           case confirmationNumber = "confirmation_number"
           case confirmed
           case contactEmail = "contact_email"
           case createdAt = "created_at"
           case currency // Ensure this matches the JSON structure
           case currentSubtotalPrice = "current_subtotal_price"
           //case currentSubtotalPriceSet = "current_subtotal_price_set"
           //case currentTotalAdditionalFeesSet = "current_total_additional_fees_set"
           case currentTotalDiscounts = "current_total_discounts"
           //case currentTotalDiscountsSet = "current_total_discounts_set"
           //case currentTotalDutiesSet = "current_total_duties_set"
           case currentTotalPrice = "current_total_price"
           //case currentTotalPriceSet = "current_total_price_set"
           case currentTotalTax = "current_total_tax"
           //case currentTotalTaxSet = "current_total_tax_set"
           case customerLocale = "customer_locale"
           case deviceID = "device_id"
           case discountCodes = "discount_codes"
           case email
           case estimatedTaxes = "estimated_taxes"
           case financialStatus = "financial_status"
           case fulfillmentStatus = "fulfillment_status"
           case landingSite = "landing_site"
           case landingSiteRef = "landing_site_ref"
           case locationID = "location_id"
           case merchantOfRecordAppID = "merchant_of_record_app_id"
           case name, note
           case noteAttributes = "note_attributes"
           case number
           case orderNumber = "order_number"
           case orderStatusURL = "order_status_url"
           case originalTotalAdditionalFeesSet = "original_total_additional_fees_set"
           case originalTotalDutiesSet = "original_total_duties_set"
           case paymentGatewayNames = "payment_gateway_names"
           case phone
           case poNumber = "po_number"
           case presentmentCurrency = "presentment_currency"
           case processedAt = "processed_at"
           case reference
           case referringSite = "referring_site"
           case sourceIdentifier = "source_identifier"
           case sourceName = "source_name"
           case sourceURL = "source_url"
           case subtotalPrice = "subtotal_price"
           //case subtotalPriceSet = "subtotal_price_set"
           case tags
           case taxExempt = "tax_exempt"
           case taxLines = "tax_lines"
           case taxesIncluded = "taxes_included"
           case test, token
           case totalDiscounts = "total_discounts"
           //case totalDiscountsSet = "total_discounts_set"
           case totalLineItemsPrice = "total_line_items_price"
           //case totalLineItemsPriceSet = "total_line_items_price_set"
           case totalOutstanding = "total_outstanding"
           case totalPrice = "total_price"
           //case totalPriceSet = "total_price_set"
           //case totalShippingPriceSet = "total_shipping_price_set"
           case totalTax = "total_tax"
           //case totalTaxSet = "total_tax_set"
           case totalTipReceived = "total_tip_received"
           case totalWeight = "total_weight"
           case updatedAt = "updated_at"
           case userID = "user_id"
           case billingAddress = "billing_address"
           case customer
           case discountApplications = "discount_applications"
           case fulfillments
           case lineItems = "line_items"
           case paymentTerms = "payment_terms"
           case refunds
           case shippingAddress = "shipping_address"
           case shippingLines = "shipping_lines"
        
    }
    
    enum Currency: String, Codable {
        case egp = "EGP"
    }
//    struct Set: Codable {
//        let shopMoney, presentmentMoney: Money
//
//        enum CodingKeys: String, CodingKey {
//            case shopMoney = "shop_money"
//            case presentmentMoney = "presentment_money"
//        }
//    }
}

enum FinancialStatus: String, Codable {
    case paid = "paid"
    case pending = "pending"
    case refunded = "refunded"
}

enum Tags: String, Codable {
    case egnitionSampleData = "egnition-sample-data"
    case empty = ""
}


// MARK: - Money
struct Money: Codable {
    let amount: String
    let currencyCode: Currency

    enum CodingKeys: String, CodingKey {
        case amount
        case currencyCode = "currency_code"
    }
}

// MARK: - Property
struct Property: Codable {
    let name: String
    let value: String
}
