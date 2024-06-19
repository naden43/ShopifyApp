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
    
    func loadData() {
        
        network.getData(endPoint: "admin/api/2024-04/draft_orders/978702565542.json", complitionHandler: { (result:Draft? , error) in
          
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
        
        let totalPrice = Double(data?.totalPrice ?? "0.0") ?? 0.0
        
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
                print(error)
            }
            
        }
        
    }
    
    func getPriceAfterApplayDiscount() -> String {
        
        let afterDiscount = (totalPrice ?? 0.0) * ((discountRate ?? 0.0)/100)
        
        let price = (totalPrice ?? 0.0) - (afterDiscount ?? 0.0)
        
        let currency = currencyService.getCurrencyType()

        let formatPrice = String(format: "%.3f" , price)

        return "\(formatPrice) \(currency)"
        
    }
    
    func getSavedMoney() -> String {
        
        let afterDiscount = (totalPrice ?? 0.0) * ((discountRate ?? 0.0)/100)
        
       // let savedMoney = (totalPrice ?? 0.0) - (discountRate ?? 0.0)
        
        let currency = currencyService.getCurrencyType()
        
        let formatAfterDiscount = String(format: "%.3f" , afterDiscount)
        return "\(formatAfterDiscount) \(currency)"
    }
    
    func getTotalMoney() -> Double {
        return totalPrice ?? 0.0
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
    
    
    func placeOrder (lineItems: [LineItem], customerId: Int, financialStatus: String) {
    
        let customer  = Customer(id: customerId)
        let order = Order( financialStatus: FinancialStatus.pending, customer: customer, lineItems: lineItems)
        let orderRequest = OrderRequest(order: order)
        
        network.postData(orderRequest, to: Constants.EndPoint.Placeorders, responseType: Order.self){ success, message, response in
            if success {
                print("Order placed successfully: \(String(describing: response))")
            } else {
                print("Failed to place order: \(String(describing: message))")
            }
        }
    }
    
    
    func getCustomerID() -> Int? {
        print("the custoemr id in user default = \(userDefualtManager.getCustomer().id ?? 0000)")
        return userDefualtManager.getCustomer().id
    }
}
