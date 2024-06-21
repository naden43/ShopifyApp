//
//  PlaceOrderViewModel.swift
//  ShopifyApp
//
//  Created by Naden on 15/06/2024.
//

import Foundation

class PlaceOrderViewModel{
    
    private let network = NetworkHandler.instance
    
    private let currencyService = CurrencyService.instance
    
    var bindData : (()->Void) = {}
    
    var bindDiscount : (()->Void) = {}
    
    private var data : DraftOrder?
    
    private var discountRate : Double?
    
    private var totalPrice : Double?
    
    var bindDiscaountCouponError : (()->Void) = {}
    
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
                self?.bindDiscaountCouponError()
            }
            
        }
        
    }
    
    func getPriceAfterApplayDiscount() -> String {
        
        let afterDiscount = (totalPrice ?? 0.0) * ((discountRate ?? 0.0)/100)
        
        let price = (totalPrice ?? 0.0) - (afterDiscount)
        
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
    
}
