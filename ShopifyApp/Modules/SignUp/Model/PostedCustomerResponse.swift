//
//  CutomerResponse.swift
//  ShopifyApp
//
//  Created by Salma on 04/06/2024.
//


import Foundation

struct PostedCustomerResponse: Codable {
    var customer: Customer?
}

struct Customer: Codable {
    var id: Int?
    var email: String?
    var createdAt: String?
    var updatedAt: String?
    var firstName: String?
    var lastName: String?
    var ordersCount: Int?
    var state: String?
    var totalSpent: String?
    var lastOrderId: Int?
    var note: String?
    var verifiedEmail: Bool?
    var multipassIdentifier: String?
    var taxExempt: Bool?
    var tags: String?
    var lastOrderName: String?
    var currency: String?
    var phone: String?
    var addresses: [Address]?
    var acceptsMarketing: Bool?
    var acceptsMarketingUpdatedAt: String?
    var marketingOptInLevel: String?
    var taxExemptions: [String]?
    var emailMarketingConsent: MarketingConsent?
    var smsMarketingConsent: MarketingConsent?
    var adminGraphqlApiId: String?
    var defaultAddress: Address?

    enum CodingKeys: String, CodingKey {
        case id, email
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case firstName = "first_name"
        case lastName = "last_name"
        case ordersCount = "orders_count"
        case state
        case totalSpent = "total_spent"
        case lastOrderId = "last_order_id"
        case note
        case verifiedEmail = "verified_email"
        case multipassIdentifier = "multipass_identifier"
        case taxExempt = "tax_exempt"
        case tags
        case lastOrderName = "last_order_name"
        case currency, phone, addresses
        case acceptsMarketing = "accepts_marketing"
        case acceptsMarketingUpdatedAt = "accepts_marketing_updated_at"
        case marketingOptInLevel = "marketing_opt_in_level"
        case taxExemptions = "tax_exemptions"
        case emailMarketingConsent = "email_marketing_consent"
        case smsMarketingConsent = "sms_marketing_consent"
        case adminGraphqlApiId = "admin_graphql_api_id"
        case defaultAddress = "default_address"
    }
}

struct Address: Codable {
    var id: Int?
    var customerId: Int?
    var firstName: String?
    var lastName: String?
    var company: String?
    var address1: String?
    var address2: String?
    var city: String?
    var province: String?
    var country: String?
    var zip: String?
    var phone: String?
    var name: String?
    var provinceCode: String?
    var countryCode: String?
    var countryName: String?
    var isDefault: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case customerId = "customer_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case company, address1, address2, city, province, country, zip, phone, name
        case provinceCode = "province_code"
        case countryCode = "country_code"
        case countryName = "country_name"
        case isDefault = "default"
    }
}

struct MarketingConsent: Codable {
    var state: String?
    var optInLevel: String?
    var consentUpdatedAt: String?
    var consentCollectedFrom: String?

    enum CodingKeys: String, CodingKey {
        case state
        case optInLevel = "opt_in_level"
        case consentUpdatedAt = "consent_updated_at"
        case consentCollectedFrom = "consent_collected_from"
    }
}
