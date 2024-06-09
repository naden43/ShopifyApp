
//
//  CustomerData.swift
//  ShopifyApp
//
//  Created by Salma on 04/06/2024.
//

import Foundation

class CustomerData : Codable {
    var first_name : String?
    var last_name  : String?
    var email : String?
    var phone : String?
    var tags : String?
    
    init(first_name: String? = nil, last_name: String? = nil, email: String? = nil, phone: String? = nil, tags: String? = nil) {
        self.first_name = first_name
        self.last_name = last_name
        self.email = email
        self.phone = phone
        self.tags = tags
    }
    
    
}

class PostedCustomer : Codable{
    
    var customer : CustomerData
    
    init(customer: CustomerData) {
        self.customer = customer
    }
}
