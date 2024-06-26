//
//  PlaceOrderViewModel.swift
//  ShopifyApp
//
//  Created by Naden on 15/06/2024.
//

import Foundation

class PlaceOrderViewModel{
    
    private let network = NetworkHandler.instance
    
    let userDefualtManager = UserDefaultsManager.shared
    
    private let currencyService = CurrencyService.instance
    
    var bindData : (()->Void) = {}
    
    var bindDiscount : (()->Void) = {}
    
    private var data : DraftOrder?
    
    private var discountRate : Double?
    
    private var totalPrice : Double?
    
    var bindEditCartAlert : (()-> Void) = {}
    
    var bindDiscaountCouponError : (()->Void) = {}
    
    func loadData() {
        
        let draftOrderID = userDefualtManager.getCustomer().shoppingCartDraftOrderId ?? ""
        network.getData(endPoint: "admin/api/2024-04/draft_orders/\(draftOrderID).json", complitionHandler: { (result:Draft? , error) in
          
            if let result = result {
                
                self.data = result.draft_order
                self.bindData()
            }
            else{
                print(error)
            }
            
        })
        
    }
    
    func getTotalPrice() -> String {
        
        let totalPrice = Double(data?.subtotalPrice ?? "0.0") ?? 0.0
        
        let afterConvert = currencyService.calcThePrice(price: totalPrice)
        
        let currency = currencyService.getCurrencyType()
        
        self.totalPrice = Double(afterConvert)
        
        return "\(afterConvert) \(currency)"
        
    }
    
    func createDiscountIfAvaliable(coupon : String) {
        
        network.getData(endPoint: "admin/api/2024-04/price_rules/\(coupon).json") { [weak self] ( result:PriceRuleData?, error) in
         
            if let result = result {
                
                self?.discountRate = Double(result.price_rule.value)
                self?.discountRate = (self?.discountRate ?? 0.0) * -1
                self?.bindDiscount()
                
            }
            else{
                self?.bindDiscaountCouponError()
            }
            
        }
        
    }
    
    func getPriceAfterApplayDiscount() -> String {
        
        let afterDiscount = (totalPrice ?? 0.0) * ((discountRate ?? 0.0)/100)
        
        let price = (totalPrice ?? 0.0) - (afterDiscount)
        
        let currency = currencyService.getCurrencyType()

        let formatPrice = String(format: "%.2f" , price)

        return "\(formatPrice) \(currency)"
        
    }
    
    func getSavedMoney() -> String {
        
        let afterDiscount = (totalPrice ?? 0.0) * ((discountRate ?? 0.0)/100)
        
       // let savedMoney = (totalPrice ?? 0.0) - (discountRate ?? 0.0)
        
        let currency = currencyService.getCurrencyType()
        
        let formatAfterDiscount = String(format: "%.2f" , afterDiscount)
        return "\(formatAfterDiscount) \(currency)"
    }
    
    func getTotalMoney() -> Double {
        
        let formatPrice = String(format: "%.2f" , totalPrice ?? 0.0)
        
        return Double(formatPrice) ?? 0.0
    }
    
    func getCurrency()-> String {
        
        return currencyService.getCurrencyType() 
    }
    
    
    func getAllProductsFromDraftOrder () -> [LineItem] {
        
        guard let items = data?.lineItems else {
            return []
        }
        return items
    }
    
    func clearAllProducts() {
        guard var listOfProducts = data, var lineItems = data?.lineItems, !lineItems.isEmpty else {
            return
        }
        let firstItem = lineItems[0]
        listOfProducts.lineItems = [firstItem]
        
        let draftOrderId = userDefualtManager.getCustomer().shoppingCartDraftOrderId ?? ""

        print("Updating draft order with only the first item: \(listOfProducts)")

        network.putData(Draft(draft_order: listOfProducts), to: "admin/api/2024-04/draft_orders/\(draftOrderId).json", responseType: Draft.self) { success, error, response in
            
            if success {
                self.data = response?.draft_order
                //self.bindData()
                print("Draft order successfully updated with only the first item retained")
            } else {
                print("Error updating draft order: \(String(describing: error))")
            }
        }
    }
    
    
    func placeOrder (lineItems: [LineItem], customerId: Int, financialStatus: String, discount_codes : [DiscountCode]) {
    
        let customer  = Customer(id: customerId)
        let order = Order( discountCodes: discount_codes, financialStatus: FinancialStatus.pending, customer: customer, lineItems: lineItems ,  inventory_behaviour: "decrement_obeying_policy")
        let orderRequest = OrderRequest(order: order)
        print("========================== order req =============== \(orderRequest)")
        network.postData(orderRequest, to: Constants.EndPoint.Placeorders, responseType: Order.self){ success, message, response in
            if success {
                print("Order placed successfully: \(String(describing: response))")
                self.clearAllProducts()
            } else {
                
                if (message  ?? "") == "422" {
                    self.bindEditCartAlert()
                }
                else
                {
                    
                }
                print("Failed to place order: \(String(describing: message))")
            }
        }
    }
    
    func getCustomerID() -> Int? {
        print("the custoemr id in user default = \(userDefualtManager.getCustomer().id ?? 0000)")
        return userDefualtManager.getCustomer().id
    }
    
    func getDiscountRate() -> Double? {
        guard let rate = discountRate else {
            return 0.0
        }
        
        print("inside PlaceOrderViewModel the discount rate is = \(rate)")
        return rate
    }
    
}
