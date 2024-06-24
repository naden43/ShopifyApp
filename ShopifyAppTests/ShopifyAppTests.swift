//
//  ShopifyAppTests.swift
//  ShopifyAppTests
//
//  Created by Naden on 19/06/2024.
//

import XCTest
@testable import ShopifyApp

final class ShopifyAppTests: XCTestCase {

    
    var networkHandler : NetworkHandler?

    var mockNetworkHandler : MockNetworkHandler?
    override func setUpWithError() throws {
        networkHandler = NetworkHandler.instance
        mockNetworkHandler = MockNetworkHandler(shouldReturnError: false)
        // Put setup code here. This method is called before the invocation of each test method in the class...
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPutData() {
        
        let myExpectation = expectation(description: "wait api result")
        
       
        var draftOrderData = DraftOrder(
            id: 979195232422,
            note: nil,
            email: "amirayousif33@gmail.com",
            taxesIncluded: false,
            currency: "EGP",
            invoiceSentAt: nil,
            createdAt: "2024-06-08T14:57:51-04:00",
            updatedAt: "2024-06-17T21:24:24-04:00",
            taxExempt: false,
            completedAt: nil,
            name: "#D14",
            status: "open",
            lineItems: [
                LineItem(id: 57751354572966, title: "bag", quantity: 1, requiresShipping: false, taxable: true, giftCard: false, fulfillmentService: "manual", grams: 0, taxLines: [TaxLine(rate: 0.14, title: "GST", price: "14.00")], name: "bag", properties: [], custom: true, price: "100.00", adminGraphqlApiId: "gid://shopify/DraftOrderLineItem/57751354572966"),
                LineItem(id: 57751354605734, variantId: 45467164377254, productId: 8178818023590, title: "ADIDAS | CLASSIC BACKPACK", variantTitle: "OS / black", sku: "AD-03-black-OS", vendor: "ADIDAS", quantity: 1, requiresShipping: true, taxable: true, giftCard: false, fulfillmentService: "manual", grams: 0, taxLines: [TaxLine(rate: 0.14, title: "GST", price: "9.80")], name: "ADIDAS | CLASSIC BACKPACK - OS / black", properties: [["name": "image_url", "value": "https://cdn.shopify.com/s/files/1/0647/8967/6198/files/85cc58608bf138a50036bcfe86a3a362.jpg?v=1717504516"]], custom: false, price: "70.00", adminGraphqlApiId: "gid://shopify/DraftOrderLineItem/57751354605734"),
                LineItem(id: 57751354638502, variantId: 45467161002150, productId: 8178817237158, title: "CONVERSE | CHUCK TAYLOR ALL STAR LO", variantTitle: "3 / white", sku: "C-01-white-3", vendor: "CONVERSE", quantity: 1, requiresShipping: true, taxable: true, giftCard: false, fulfillmentService: "manual", grams: 0, taxLines: [TaxLine(rate: 0.14, title: "GST", price: "14.00")], name: "CONVERSE | CHUCK TAYLOR ALL STAR LO - 3 / white", properties: [["name": "image_url", "value": "https://cdn.shopify.com/s/files/1/0647/8967/6198/files/fae150570c8ce6ddc4f787bf77b02c95.jpg?v=1717504472"]], custom: false, price: "100.00", adminGraphqlApiId: "gid://shopify/DraftOrderLineItem/57751354638502")
            ],
            shippingAddress: nil,
            billingAddress: nil,
            invoiceUrl: "https://mad44-sv-team4.myshopify.com/64789676198/invoices/c891150134a503244292d06c63a5f537",
            appliedDiscount: nil,
            orderId: nil,
            shippingLine: nil,
            taxLines: [
                TaxLine(rate: 0.14, title: "GST", price: "14.00"),
                TaxLine(rate: 0.14, title: "GST", price: "9.80"),
                TaxLine(rate: 0.14, title: "GST", price: "14.00")
            ],
            tags: "",
            noteAttributes: [],
            totalPrice: "307.80",
            subtotalPrice: "270.00",
            totalTax: "37.80",
            paymentTerms: nil,
            adminGraphqlApiId: "gid://shopify/DraftOrder/979195232422",
            customer: nil  // Replace with actual customer data if available
        )

        networkHandler?.putData(Draft(draft_order: draftOrderData), to: "admin/api/2024-04/draft_orders/979195232422.json", responseType: Draft.self){ success, error, response in
                        
                        if  success == true {
                            
                            XCTAssertNotNil(response)
                                                        
                            myExpectation.fulfill()
                        }
                        else{
                            
                            myExpectation.fulfill()
                            XCTFail()
                            
                        }
                    }
                   
                
        waitForExpectations(timeout: 10)
    }
    
    func testPutDataToFail() {
        
        let myExpectation = expectation(description: "wait api result")
        
       
        var draftOrderData = DraftOrder(
            id: 979195232422,
            note: nil,
            email: "amirayousif33@gmail.com",
            taxesIncluded: false,
            currency: "EGP",
            invoiceSentAt: nil,
            createdAt: "2024-06-08T14:57:51-04:00",
            updatedAt: "2024-06-17T21:24:24-04:00",
            taxExempt: false,
            completedAt: nil,
            name: "#D14",
            status: "open",
            lineItems: [
                LineItem(id: 57751354572966, title: "bag", quantity: 1, requiresShipping: false, taxable: true, giftCard: false, fulfillmentService: "manual", grams: 0, taxLines: [TaxLine(rate: 0.14, title: "GST", price: "14.00")], name: "bag", properties: [], custom: true, price: "100.00", adminGraphqlApiId: "gid://shopify/DraftOrderLineItem/57751354572966"),
                LineItem(id: 57751354605734, variantId: 45467164377254, productId: 8178818023590, title: "ADIDAS | CLASSIC BACKPACK", variantTitle: "OS / black", sku: "AD-03-black-OS", vendor: "ADIDAS", quantity: 1, requiresShipping: true, taxable: true, giftCard: false, fulfillmentService: "manual", grams: 0, taxLines: [TaxLine(rate: 0.14, title: "GST", price: "9.80")], name: "ADIDAS | CLASSIC BACKPACK - OS / black", properties: [["name": "image_url", "value": "https://cdn.shopify.com/s/files/1/0647/8967/6198/files/85cc58608bf138a50036bcfe86a3a362.jpg?v=1717504516"]], custom: false, price: "70.00", adminGraphqlApiId: "gid://shopify/DraftOrderLineItem/57751354605734"),
                LineItem(id: 57751354638502, variantId: 45467161002150, productId: 8178817237158, title: "CONVERSE | CHUCK TAYLOR ALL STAR LO", variantTitle: "3 / white", sku: "C-01-white-3", vendor: "CONVERSE", quantity: 1, requiresShipping: true, taxable: true, giftCard: false, fulfillmentService: "manual", grams: 0, taxLines: [TaxLine(rate: 0.14, title: "GST", price: "14.00")], name: "CONVERSE | CHUCK TAYLOR ALL STAR LO - 3 / white", properties: [["name": "image_url", "value": "https://cdn.shopify.com/s/files/1/0647/8967/6198/files/fae150570c8ce6ddc4f787bf77b02c95.jpg?v=1717504472"]], custom: false, price: "100.00", adminGraphqlApiId: "gid://shopify/DraftOrderLineItem/57751354638502")
            ],
            shippingAddress: nil,
            billingAddress: nil,
            invoiceUrl: "https://mad44-sv-team4.myshopify.com/64789676198/invoices/c891150134a503244292d06c63a5f537",
            appliedDiscount: nil,
            orderId: nil,
            shippingLine: nil,
            taxLines: [
                TaxLine(rate: 0.14, title: "GST", price: "14.00"),
                TaxLine(rate: 0.14, title: "GST", price: "9.80"),
                TaxLine(rate: 0.14, title: "GST", price: "14.00")
            ],
            tags: "",
            noteAttributes: [],
            totalPrice: "307.80",
            subtotalPrice: "270.00",
            totalTax: "37.80",
            paymentTerms: nil,
            adminGraphqlApiId: "gid://shopify/DraftOrder/979195232422",
            customer: nil  // Replace with actual customer data if available
        )

        networkHandler?.putData(draftOrderData, to: "admin/api/2024-04/draft_orders/979195232422.json", responseType: Draft.self){ success, error, response in
                        
                        if  success == true {
                            
                            XCTAssertNotNil(response)
                                                        
                            myExpectation.fulfill()
                        }
                        else{
                            XCTAssertNotNil(error)
                            myExpectation.fulfill()
                            //XCTFail()
                            
                        }
                    }
                   
                
        waitForExpectations(timeout: 10)
    }
    
    func testMockPutData() {
        
        let draftOrderData = DraftOrder(
            id: 979195232422,
            note: nil,
            email: "amirayousif33@gmail.com",
            taxesIncluded: false,
            currency: "EGP",
            invoiceSentAt: nil,
            createdAt: "2024-06-08T14:57:51-04:00",
            updatedAt: "2024-06-17T21:24:24-04:00",
            taxExempt: false,
            completedAt: nil,
            name: "#D14",
            status: "open",
            lineItems: [
                LineItem(id: 57751354572966, title: "bag", quantity: 1, requiresShipping: false, taxable: true, giftCard: false, fulfillmentService: "manual", grams: 0, taxLines: [TaxLine(rate: 0.14, title: "GST", price: "14.00")], name: "bag", properties: [], custom: true, price: "100.00", adminGraphqlApiId: "gid://shopify/DraftOrderLineItem/57751354572966"),
                LineItem(id: 57751354605734, variantId: 45467164377254, productId: 8178818023590, title: "ADIDAS | CLASSIC BACKPACK", variantTitle: "OS / black", sku: "AD-03-black-OS", vendor: "ADIDAS", quantity: 1, requiresShipping: true, taxable: true, giftCard: false, fulfillmentService: "manual", grams: 0, taxLines: [TaxLine(rate: 0.14, title: "GST", price: "9.80")], name: "ADIDAS | CLASSIC BACKPACK - OS / black", properties: [["name": "image_url", "value": "https://cdn.shopify.com/s/files/1/0647/8967/6198/files/85cc58608bf138a50036bcfe86a3a362.jpg?v=1717504516"]], custom: false, price: "70.00", adminGraphqlApiId: "gid://shopify/DraftOrderLineItem/57751354605734"),
                LineItem(id: 57751354638502, variantId: 45467161002150, productId: 8178817237158, title: "CONVERSE | CHUCK TAYLOR ALL STAR LO", variantTitle: "3 / white", sku: "C-01-white-3", vendor: "CONVERSE", quantity: 1, requiresShipping: true, taxable: true, giftCard: false, fulfillmentService: "manual", grams: 0, taxLines: [TaxLine(rate: 0.14, title: "GST", price: "14.00")], name: "CONVERSE | CHUCK TAYLOR ALL STAR LO - 3 / white", properties: [["name": "image_url", "value": "https://cdn.shopify.com/s/files/1/0647/8967/6198/files/fae150570c8ce6ddc4f787bf77b02c95.jpg?v=1717504472"]], custom: false, price: "100.00", adminGraphqlApiId: "gid://shopify/DraftOrderLineItem/57751354638502")
            ],
            shippingAddress: nil,
            billingAddress: nil,
            invoiceUrl: "https://mad44-sv-team4.myshopify.com/64789676198/invoices/c891150134a503244292d06c63a5f537",
            appliedDiscount: nil,
            orderId: nil,
            shippingLine: nil,
            taxLines: [
                TaxLine(rate: 0.14, title: "GST", price: "14.00"),
                TaxLine(rate: 0.14, title: "GST", price: "9.80"),
                TaxLine(rate: 0.14, title: "GST", price: "14.00")
            ],
            tags: "",
            noteAttributes: [],
            totalPrice: "307.80",
            subtotalPrice: "270.00",
            totalTax: "37.80",
            paymentTerms: nil,
            adminGraphqlApiId: "gid://shopify/DraftOrder/979195232422",
            customer: nil  // Replace with actual customer data if available
        )

    
        mockNetworkHandler?.putData( draftOrderData , to: "", responseType: Draft.self , completion: { boolResult, error, result in
            
            if let error = error {
                
                XCTAssertNil(result)
                XCTFail()
            }
            
            if let result = result {
                

                XCTAssertEqual(result.draft_order?.lineItems?.count, 1)
                
            }
            
            
        })
    }
    
    
    func testPostData() {
        let myExpectation = expectation(description: "wait api result")
        
        let draftOrderData = DraftOrder(
            id: 979195232422,
            note: nil,
            email: "amirayousif33@gmail.com",
            taxesIncluded: false,
            currency: "EGP",
            invoiceSentAt: nil,
            createdAt: "2024-06-08T14:57:51-04:00",
            updatedAt: "2024-06-17T21:24:24-04:00",
            taxExempt: false,
            completedAt: nil,
            name: "#D14",
            status: "open",
            lineItems: [
                LineItem(id: 57751354572966, title: "bag", quantity: 1, requiresShipping: false, taxable: true, giftCard: false, fulfillmentService: "manual", grams: 0, taxLines: [TaxLine(rate: 0.14, title: "GST", price: "14.00")], name: "bag", properties: [], custom: true, price: "100.00", adminGraphqlApiId: "gid://shopify/DraftOrderLineItem/57751354572966"),
                LineItem(id: 57751354605734, variantId: 45467164377254, productId: 8178818023590, title: "ADIDAS | CLASSIC BACKPACK", variantTitle: "OS / black", sku: "AD-03-black-OS", vendor: "ADIDAS", quantity: 1, requiresShipping: true, taxable: true, giftCard: false, fulfillmentService: "manual", grams: 0, taxLines: [TaxLine(rate: 0.14, title: "GST", price: "9.80")], name: "ADIDAS | CLASSIC BACKPACK - OS / black", properties: [["name": "image_url", "value": "https://cdn.shopify.com/s/files/1/0647/8967/6198/files/85cc58608bf138a50036bcfe86a3a362.jpg?v=1717504516"]], custom: false, price: "70.00", adminGraphqlApiId: "gid://shopify/DraftOrderLineItem/57751354605734"),
                LineItem(id: 57751354638502, variantId: 45467161002150, productId: 8178817237158, title: "CONVERSE | CHUCK TAYLOR ALL STAR LO", variantTitle: "3 / white", sku: "C-01-white-3", vendor: "CONVERSE", quantity: 1, requiresShipping: true, taxable: true, giftCard: false, fulfillmentService: "manual", grams: 0, taxLines: [TaxLine(rate: 0.14, title: "GST", price: "14.00")], name: "CONVERSE | CHUCK TAYLOR ALL STAR LO - 3 / white", properties: [["name": "image_url", "value": "https://cdn.shopify.com/s/files/1/0647/8967/6198/files/fae150570c8ce6ddc4f787bf77b02c95.jpg?v=1717504472"]], custom: false, price: "100.00", adminGraphqlApiId: "gid://shopify/DraftOrderLineItem/57751354638502")
            ],
            shippingAddress: nil,
            billingAddress: nil,
            invoiceUrl: "https://mad44-sv-team4.myshopify.com/64789676198/invoices/c891150134a503244292d06c63a5f537",
            appliedDiscount: nil,
            orderId: nil,
            shippingLine: nil,
            taxLines: [
                TaxLine(rate: 0.14, title: "GST", price: "14.00"),
                TaxLine(rate: 0.14, title: "GST", price: "9.80"),
                TaxLine(rate: 0.14, title: "GST", price: "14.00")
            ],
            tags: "",
            noteAttributes: [],
            totalPrice: "307.80",
            subtotalPrice: "270.00",
            totalTax: "37.80",
            paymentTerms: nil,
            adminGraphqlApiId: "gid://shopify/DraftOrder/979195232422",
            customer: nil
        )

        networkHandler?.postData(draftOrderData, to: "admin/api/2024-04/draft_orders.json", responseType: Draft.self) { success, error, response in
            if success {
                XCTAssertNotNil(response)
                myExpectation.fulfill()
            } else {
                XCTAssertNotNil(error)
                myExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 10)
    }
    
   /* func testMockPostData() {
        let draftOrderData = DraftOrder(
            id: 979195232422,
            note: nil,
            email: "amirayousif33@gmail.com",
            taxesIncluded: false,
            currency: "EGP",
            invoiceSentAt: nil,
            createdAt: "2024-06-08T14:57:51-04:00",
            updatedAt: "2024-06-17T21:24:24-04:00",
            taxExempt: false,
            completedAt: nil,
            name: "#D14",
            status: "open",
            lineItems: [
                LineItem(id: 57751354572966, title: "bag", quantity: 1, requiresShipping: false, taxable: true, giftCard: false, fulfillmentService: "manual", grams: 0, taxLines: [TaxLine(rate: 0.14, title: "GST", price: "14.00")], name: "bag", properties: [], custom: true, price: "100.00", adminGraphqlApiId: "gid://shopify/DraftOrderLineItem/57751354572966"),
                LineItem(id: 57751354605734, variantId: 45467164377254, productId: 8178818023590, title: "ADIDAS | CLASSIC BACKPACK", variantTitle: "OS / black", sku: "AD-03-black-OS", vendor: "ADIDAS", quantity: 1, requiresShipping: true, taxable: true, giftCard: false, fulfillmentService: "manual", grams: 0, taxLines: [TaxLine(rate: 0.14, title: "GST", price: "9.80")], name: "ADIDAS | CLASSIC BACKPACK - OS / black", properties: [["name": "image_url", "value": "https://cdn.shopify.com/s/files/1/0647/8967/6198/files/85cc58608bf138a50036bcfe86a3a362.jpg?v=1717504516"]], custom: false, price: "70.00", adminGraphqlApiId: "gid://shopify/DraftOrderLineItem/57751354605734"),
                LineItem(id: 57751354638502, variantId: 45467161002150, productId: 8178817237158, title: "CONVERSE | CHUCK TAYLOR ALL STAR LO", variantTitle: "3 / white", sku: "C-01-white-3", vendor: "CONVERSE", quantity: 1, requiresShipping: true, taxable: true, giftCard: false, fulfillmentService: "manual", grams: 0, taxLines: [TaxLine(rate: 0.14, title: "GST", price: "14.00")], name: "CONVERSE | CHUCK TAYLOR ALL STAR LO - 3 / white", properties: [["name": "image_url", "value": "https://cdn.shopify.com/s/files/1/0647/8967/6198/files/fae150570c8ce6ddc4f787bf77b02c95.jpg?v=1717504472"]], custom: false, price: "100.00", adminGraphqlApiId: "gid://shopify/DraftOrderLineItem/57751354638502")
            ],
            shippingAddress: nil,
            billingAddress: nil,
            invoiceUrl: "https://mad44-sv-team4.myshopify.com/64789676198/invoices/c891150134a503244292d06c63a5f537",
            appliedDiscount: nil,
            orderId: nil,
            shippingLine: nil,
            taxLines: [
                TaxLine(rate: 0.14, title: "GST", price: "14.00"),
                TaxLine(rate: 0.14, title: "GST", price: "9.80"),
                TaxLine(rate: 0.14, title: "GST", price: "14.00")
            ],
            tags: "",
            noteAttributes: [],
            totalPrice: "307.80",
            subtotalPrice: "270.00",
            totalTax: "37.80",
            paymentTerms: nil,
            adminGraphqlApiId: "gid://shopify/DraftOrder/979195232422",
            customer: nil
        )
        
        mockNetworkHandler?.postData(draftOrderData, to: "admin/api/2024-04/draft_orders.json", responseType: Draft.self) { success, error, response in
            XCTAssertTrue(success)
            XCTAssertNil(error)
            XCTAssertNotNil(response)
        }
    }*/

    /*func testMockPostDataWithError() {
        mockNetworkHandler = MockNetworkHandler(shouldReturnError: true)

        let draftOrderData = DraftOrder(
            id: 979195232422,
            note: nil,
            email: "amirayousif33@gmail.com",
            taxesIncluded: false,
            currency: "EGP",
            invoiceSentAt: nil,
            createdAt: "2024-06-08T14:57:51-04:00",
            updatedAt: "2024-06-17T21:24:24-04:00",
            taxExempt: false,
            completedAt: nil,
            name: "#D14",
            status: "open",
            lineItems: [
                LineItem(id: 57751354572966, title: "bag", quantity: 1, requiresShipping: false, taxable: true, giftCard: false, fulfillmentService: "manual", grams: 0, taxLines: [TaxLine(rate: 0.14, title: "GST", price: "14.00")], name: "bag", properties: [], custom: true, price: "100.00", adminGraphqlApiId: "gid://shopify/DraftOrderLineItem/57751354572966"),
                LineItem(id: 57751354605734, variantId: 45467164377254, productId: 8178818023590, title: "ADIDAS | CLASSIC BACKPACK", variantTitle: "OS / black", sku: "AD-03-black-OS", vendor: "ADIDAS", quantity: 1, requiresShipping: true, taxable: true, giftCard: false, fulfillmentService: "manual", grams: 0, taxLines: [TaxLine(rate: 0.14, title: "GST", price: "9.80")], name: "ADIDAS | CLASSIC BACKPACK - OS / black", properties: [["name": "image_url", "value": "https://cdn.shopify.com/s/files/1/0647/8967/6198/files/85cc58608bf138a50036bcfe86a3a362.jpg?v=1717504516"]], custom: false, price: "70.00", adminGraphqlApiId: "gid://shopify/DraftOrderLineItem/57751354605734"),
                LineItem(id: 57751354638502, variantId: 45467161002150, productId: 8178817237158, title: "CONVERSE | CHUCK TAYLOR ALL STAR LO", variantTitle: "3 / white", sku: "C-01-white-3", vendor: "CONVERSE", quantity: 1, requiresShipping: true, taxable: true, giftCard: false, fulfillmentService: "manual", grams: 0, taxLines: [TaxLine(rate: 0.14, title: "GST", price: "14.00")], name: "CONVERSE | CHUCK TAYLOR ALL STAR LO - 3 / white", properties: [["name": "image_url", "value": "https://cdn.shopify.com/s/files/1/0647/8967/6198/files/fae150570c8ce6ddc4f787bf77b02c95.jpg?v=1717504472"]], custom: false, price: "100.00", adminGraphqlApiId: "gid://shopify/DraftOrderLineItem/57751354638502")
            ],
            shippingAddress: nil,
            billingAddress: nil,
            invoiceUrl: "https://mad44-sv-team4.myshopify.com/64789676198/invoices/c891150134a503244292d06c63a5f537",
            appliedDiscount: nil,
            orderId: nil,
            shippingLine: nil,
            taxLines: [
                TaxLine(rate: 0.14, title: "GST", price: "14.00"),
                TaxLine(rate: 0.14, title: "GST", price: "9.80"),
                TaxLine(rate: 0.14, title: "GST", price: "14.00")
            ],
            tags: "",
            noteAttributes: [],
            totalPrice: "307.80",
            subtotalPrice: "270.00",
            totalTax: "37.80",
            paymentTerms: nil,
            adminGraphqlApiId: "gid://shopify/DraftOrder/979195232422",
            customer: nil
        )
        
        mockNetworkHandler?.postData(draftOrderData, to: "admin/api/2024-04/draft_orders.json", responseType: Draft.self) { success, error, response in
            XCTAssertFalse(success)
            XCTAssertNotNil(error)
            XCTAssertNil(response)
        }
    }*/

    func testGetData() {
        let myExpectation = expectation(description: "wait api result")
        
        networkHandler?.getData(endPoint: "admin/api/2024-04/draft_orders/979195232422.json", complitionHandler: { (response: Draft?, error) in
            if error == "Success" {
                XCTAssertNotNil(response)
                myExpectation.fulfill()
            } else {
                XCTFail("Request failed with error: \(error ?? "unknown error")")
                myExpectation.fulfill()
            }
        })
        waitForExpectations(timeout: 10)
    }


    func testGetDataToFail() {
        let myExpectation = expectation(description: "wait api result")
        networkHandler?.getData(endPoint: "admin/api/2024-04/invalid_endpoint.json", complitionHandler: { (response: Draft?, error) in
            if let error = error {
                XCTAssertNotNil(error, "Expected an error but got none")
                myExpectation.fulfill()
            } else {
                XCTFail("Expected failure but got success")
                myExpectation.fulfill()
            }
        })
        
        waitForExpectations(timeout: 10)
    }
    
    func testDeleteAddress () {
        let myExpectation = expectation(description: "wait api result")
            let addressId = 8864222675110
            let endpoint = "admin/api/2024-04/customers/7906517647526/addresses/\(addressId).json"
            
            networkHandler?.deleteAddress(endPoint: endpoint, completion: { success in
                if success {
                    myExpectation.fulfill()
                } else {
                    XCTFail("Delete address failed")
                    myExpectation.fulfill()
                }
            })
            waitForExpectations(timeout: 10)
    }
    
    
    func testDeleteAddressToFail() {
        let myExpectation = expectation(description: "wait api result")
        let invalidAddressId = 9999999999999
        let endpoint = "admin/api/2024-04/customers/7903151259814/addresses/\(invalidAddressId).json"
        
        networkHandler?.deleteAddress(endPoint: endpoint, completion: { success in
            if success {
                XCTFail("Expected failure but got success")
                myExpectation.fulfill()
            } else {
                myExpectation.fulfill()
            }
        })
        waitForExpectations(timeout: 10)
    }
    
    func testMockGetData() {
            mockNetworkHandler?.getData(from: "", responseType: Draft.self) { success, errorMessage, result in
                if let errorMessage = errorMessage {
                    XCTAssertNil(result)
                    XCTFail("Error: \(errorMessage)")
                }
                
                if let result = result {
                    XCTAssertEqual(result.draft_order?.id, 979195232422)
                }
            }
        }
    
    func testMockDeleteData() {
            mockNetworkHandler?.deleteData(from: "") { success, errorMessage in
                if let errorMessage = errorMessage {
                    XCTAssertFalse(success)
                    XCTFail("Error: \(errorMessage)")
                } else {
                    XCTAssertTrue(success)
                }
            }
        }

}
