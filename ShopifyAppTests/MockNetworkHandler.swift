//
//  MockNetworkHandler.swift
//  ShopifyAppTests
//
//  Created by Naden on 21/06/2024.
//

import Foundation

@testable import ShopifyApp

class MockNetworkHandler {
    
    
    var shouldReturnError : Bool
    
    init(shouldReturnError: Bool) {
        self.shouldReturnError = shouldReturnError
    }
    
    
    let fakeAddressJson : [String: Any] = [
        "addresses": [
            [
                "id": 8862206623910,
                "customer_id": 7903151259814,
                "first_name": "aya",
                "last_name": "mostafa",
                "company": null,
                "address1": "abdelazizaburahmastret",
                "address2": null,
                "city": "Port Said",
                "province": null,
                "country": "Egypt",
                "zip": null,
                "phone": "01128273410",
                "name": "aya mostafa",
                "province_code": null,
                "country_code": "EG",
                "country_name": "Egypt",
                "default": true
            ]
        ]
    ]
    
    
    let fackDraftOrderJson: [String: Any] = [
        "draft_order": [
            "id": 979195232422,
            "note": NSNull(),
            "email": "amirayousif33@gmail.com",
            "taxes_included": false,
            "currency": "EGP",
            "invoice_sent_at": NSNull(),
            "created_at": "2024-06-08T14:57:51-04:00",
            "updated_at": "2024-06-17T21:24:24-04:00",
            "tax_exempt": false,
            "completed_at": NSNull(),
            "name": "#D14",
            "status": "open",
            "line_items": [
                [
                    "id": 57751354572966,
                    "variant_id": NSNull(),
                    "product_id": NSNull(),
                    "title": "bag",
                    "variant_title": NSNull(),
                    "sku": NSNull(),
                    "vendor": NSNull(),
                    "quantity": 1,
                    "requires_shipping": false,
                    "taxable": true,
                    "gift_card": false,
                    "fulfillment_service": "manual",
                    "grams": 0,
                    "tax_lines": [
                        [
                            "rate": 0.14,
                            "title": "GST",
                            "price": "14.00"
                        ]
                    ],
                    "applied_discount": NSNull(),
                    "name": "bag",
                    "properties": [],
                    "custom": true,
                    "price": "100.00",
                    "admin_graphql_api_id": "gid://shopify/DraftOrderLineItem/57751354572966"
                ]
            ],
            "shipping_address": NSNull(),
            "billing_address": NSNull(),
            "invoice_url": "https://mad44-sv-team4.myshopify.com/64789676198/invoices/c891150134a503244292d06c63a5f537",
            "applied_discount": NSNull(),
            "order_id": NSNull(),
            "shipping_line": NSNull(),
            "tax_lines": [
                [
                    "rate": 0.14,
                    "title": "GST",
                    "price": "14.00"
                ],
                [
                    "rate": 0.14,
                    "title": "GST",
                    "price": "9.80"
                ],
                [
                    "rate": 0.14,
                    "title": "GST",
                    "price": "14.00"
                ]
            ],
            "tags": "",
            "note_attributes": [],
            "total_price": "307.80",
            "subtotal_price": "270.00",
            "total_tax": "37.80",
            "payment_terms": NSNull(),
            "admin_graphql_api_id": "gid://shopify/DraftOrder/979195232422",
            "customer": [
                "id": 7877044240550,
                "email": "amirayousif33@gmail.com",
                "created_at": "2024-06-08T14:57:50-04:00",
                "updated_at": "2024-06-20T17:24:18-04:00",
                "first_name": "Amira",
                "last_name": "yousef",
                "orders_count": 0,
                "state": "disabled",
                "total_spent": "0.00",
                "last_order_id": NSNull(),
                "note": "979195199654,979195232422",
                "verified_email": true,
                "multipass_identifier": NSNull(),
                "tax_exempt": false,
                "tags": "123456",
                "last_order_name": NSNull(),
                "currency": "EGP",
                "phone": "+201156338776",
                "tax_exemptions": [],
                "email_marketing_consent": [
                    "state": "not_subscribed",
                    "opt_in_level": "single_opt_in",
                    "consent_updated_at": NSNull()
                ],
                "sms_marketing_consent": [
                    "state": "not_subscribed",
                    "opt_in_level": "single_opt_in",
                    "consent_updated_at": NSNull(),
                    "consent_collected_from": "OTHER"
                ],
                "admin_graphql_api_id": "gid://shopify/Customer/7877044240550",
                "default_address": [
                    "id": 8854219620518,
                    "customer_id": 7877044240550,
                    "first_name": "Amira",
                    "last_name": "Ahmed",
                    "company": NSNull(),
                    "address1": "street 300",
                    "address2": NSNull(),
                    "city": "Vancouver",
                    "province": NSNull(),
                    "country": "Canada",
                    "zip": NSNull(),
                    "phone": "01037036728",
                    "name": "Amira Ahmed",
                    "province_code": NSNull(),
                    "country_code": "CA",
                    "country_name": "Canada",
                    "default": true
                ]
            ]
        ]
    ]

    

    
    func putData<T: Encodable, U: Decodable>(_ data: T, to endpoint: String, responseType: U.Type, completion: @escaping (Bool, String? , U?) -> Void){
        
        
        var result = Draft()
        
        do {
            
            let data  = try JSONSerialization.data(withJSONObject: fackDraftOrderJson)
            
            result = try JSONDecoder().decode(Draft.self, from: data)
            
        }catch let error {
            
            print(error.localizedDescription)
        }
        
        
       
        
        if shouldReturnError {
            
            completion(false , "error message" , nil)
        }
        else {
            print("here")
            completion(true , nil , result as? U)
        }
    
    }
    
    
    func postData<T: Encodable, U: Decodable>(_ data: T, to endpoint: String, responseType: U.Type, completion: @escaping (Bool, String? , U?) -> Void) {
             guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
                 completion(false, "Invalid URL",nil)
                 return
             }
        
            print("the url is = \(url)")
             let headers: HTTPHeaders = [
                 "Authorization": authHeader,
                 "Content-Type": "application/json"
             ]
        
        do {
            let jsonData = try JSONEncoder().encode(data)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("Request JSON: \(jsonString)")
            }
        } catch {
            completion(false, "Failed to encode JSON: \(error.localizedDescription)", nil)
            return
        }
        
             AF.request(url, method: .post, parameters: data, encoder: JSONParameterEncoder.default, headers: headers)
                 .validate()
                 .responseDecodable(of: U.self) { response in
                     switch response.result {
                     case .success(let value):
                         completion(true, "succeeded",value)
                     case .failure(let error):
                         completion(false, "Request error i post fuction: \(error.localizedDescription) \(response.response?.statusCode)" , nil)
                     }
            }
        
        if shouldReturnError {
            
            completion(false , "error message" , nil)
        }
        else {
            print("here")
            completion(true , nil , result as? U)
        }
    }
    
    
    func getData<U: Decodable>(from endpoint: String, responseType: U.Type, completion: @escaping (Bool, String?, U?) -> Void) {
            var result = Draft()
            
            do {
                let data = try JSONSerialization.data(withJSONObject: fackDraftOrderJson)
                result = try JSONDecoder().decode(Draft.self, from: data)
            } catch let error {
                print(error.localizedDescription)
            }
            
            if shouldReturnError {
                completion(false, "error message", nil)
            } else {
                completion(true, nil, result as? U)
            }
        }
    
    func deleteData(from endpoint: String, completion: @escaping (Bool, String?) -> Void) {
          if shouldReturnError {
              completion(false, "error message")
          } else {
              let addresses = fakeAddressJson["addresses"] as! [[String: Any]]
              let filteredAddresses = addresses.filter { $0["id"] as! Int != 8862206623910 }
              
              if addresses.count == filteredAddresses.count {
                  completion(false, "Address not found")
              } else {
                  completion(true, nil)
              }
          }
      }
        
    
    enum responseError : Error {
        
        case error
    }
}

