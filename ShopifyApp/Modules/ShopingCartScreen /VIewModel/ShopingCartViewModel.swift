//
//  ShopingCartViewModel.swift
//  ShopifyApp
//
//  Created by Naden on 07/06/2024.
//
// 979195232422
import Foundation

class ShopingCartViewModel {
    
    var network : NetworkHandler?
    
    var userDefualtManager = UserDefaultsManager.shared
    
    var currencyService : CurrencyService = CurrencyService.instance
    
    var listOfProducts : DraftOrder?
    
    var productImages : [String] = []
    
    var bindData:(()->Void) = {}
    
    var totalPrice : String = ""
    
    var produtsAmount : [Int : Int] = [:]
    
    init(network: NetworkHandler) {
        self.network = network
        
    }
    
    func loadData(){
        
        network?.getData(endPoint: "admin/api/2024-04/draft_orders/978702532774.json", completionHandler: { (result:Draft? , error) in
            print("enter")
            guard let result = result else {
                return
            }
            print(result)
            self.listOfProducts = result.draft_order
            
            for items in self.listOfProducts?.lineItems ?? [] {
                
                self.network?.getData(endPoint: "admin/api/2024-04/variants/\(items.variantId ?? 0).json")
                { (result:VarientData?, error) in
                    
                    self.produtsAmount[Int(result?.variant?.id ?? 0)] = result?.variant?.inventoryQuantity
                    
                    print(self.produtsAmount)
                    
                    self.bindData()
                }
                
            }
            
            self.totalPrice = result.draft_order?.totalPrice ?? "0"
           
            self.bindData()
        })
        
    }

    
    func getTotalPrice()->String{
        if let totalPrice = listOfProducts?.totalPrice {
            return String(totalPrice)
        } else {
            return "Total price not available"
        }
    }
    func getProductByIndex(index:Int) -> LineItem {
        
        return (listOfProducts?.lineItems?[index+1])!
    }
    
    func deleteTheProductAmount(varientId : Int){
        
        produtsAmount.removeValue(forKey: varientId)
    }
    
    func allowedProductAmount(varientId:Int) -> Int {
        
        let amount = produtsAmount[varientId] ?? 0
        
        var returnedAmount = Int(Double(amount) * 0.5)
        
        if returnedAmount <= 0 {
            return 1
        }
        else {
            return returnedAmount
        }
        
    }
    
    func deleteTheProductFromShopingCart(index:Int){
        
        listOfProducts?.lineItems?.remove(at: index+1)
        
        network?.putData(Draft(draft_order: listOfProducts), to: "admin/api/2024-04/draft_orders/978702532774.json", responseType: Draft.self){ success, error, response in
            
            if  success == true {
                self.listOfProducts = response?.draft_order
                self.bindData()
            }
            else{
                print(error)
            }
        }
        
    }
    
    func getImageByIndex(index:Int)->String{
        print(produtsAmount)
        return (listOfProducts?.lineItems?[index+1].properties?[0]["value"])!
    }
    
    func getProductsCount()-> Int {
        
        return ((listOfProducts?.lineItems?.count ?? 1) - 1)
        
    }
    
    func getCurrencyType()->String {
        
        return currencyService.getCurrencyType()
    }
    
    
    func calcThePrice(price:Double) -> String
    {
        return currencyService.calcThePrice(price: price)
    }

    func getProductAmount(index:Int) -> Int?{
     
        let varientId = listOfProducts?.lineItems?[index+1].variantId
        
        return produtsAmount[Int(varientId ?? 0) ]
    }
    
    
    func productAmountAvaliable(index:Int) -> Bool {
        
        let varientId = listOfProducts?.lineItems?[index+1].variantId
        
        guard let amount = produtsAmount[Int(varientId ?? 0) ] else {
            return true
        }
        
        if allowedProductAmount(varientId: Int(varientId ?? 0) ) <  listOfProducts?.lineItems?[index+1].quantity ?? 0 {
            return false
        }
        else {
            return true
        }
        
    }
    
    func increaseTheQuantityOfProduct(index:Int){
        let quantity = listOfProducts?.lineItems?[index+1].quantity ?? 0
        listOfProducts?.lineItems?[index+1].quantity = quantity + 1
        
        network?.putData(Draft(draft_order: listOfProducts), to: "admin/api/2024-04/draft_orders/978702532774.json", responseType: Draft.self){ success, error, response in
            
            if success == true {
                self.listOfProducts = response?.draft_order
                self.bindData()
            }
            else{
                print(error)
            }
        }
        
        
    }
    
    func decrementTheQuantityOfProduct(index:Int){
        
        let quantity = listOfProducts?.lineItems?[index+1].quantity ?? 0
        listOfProducts?.lineItems?[index+1].quantity = quantity - 1 //(listOfProducts?.lineItems?[index].quantity ?? 0) - 1
        
        network?.putData(Draft(draft_order: listOfProducts), to: "admin/api/2024-04/draft_orders/978702532774.json", responseType: Draft.self){ success, error, response in
            
            if success == true {
                self.listOfProducts = response?.draft_order
                print("success")
                self.bindData()
            }
            else{
                print(error)
            }
        }
        
    }
    
    func avaliableToCheckOut() -> Bool{
        
        print("here")
        for items in listOfProducts?.lineItems ?? [] {
            
            if let amount = produtsAmount[Int(items.variantId ?? 0)] {
                print(amount)
                print(items.quantity)
                if allowedProductAmount(varientId: Int(items.variantId ?? 0)) < items.quantity! {
                    return false
                }
            }
            
        }
        
        return true
    }
    
}
