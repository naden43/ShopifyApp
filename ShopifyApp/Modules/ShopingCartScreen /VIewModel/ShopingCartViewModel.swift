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
    
    var productSizeAndColor : [Int : [String]] = [ 1 :  []]
    
//    private var cartItems: [LineItem] = []
    
    init(network: NetworkHandler) {
        self.network = network
        
    }
    

    
    private func getShopingCartDraftOrderId() -> String {
        
        return userDefualtManager.getCustomer().shoppingCartDraftOrderId ?? " "
    }
    
    func loadData(){
        
        
        let draftOrderId = getShopingCartDraftOrderId()
        network?.getData(endPoint: "admin/api/2024-04/draft_orders/\(draftOrderId).json", complitionHandler: { (result:Draft? , error) in
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
                    
                    self.productSizeAndColor[Int(result?.variant?.id ?? 0)] = [result?.variant?.option1 ?? "" , result?.variant?.option2 ?? ""]
                    
                    print("\(result) here error ")
                    
                    print("here \(self.produtsAmount)")
                    
                    self.bindData()
                }
                
            }
            
            self.totalPrice = result.draft_order?.subtotalPrice ?? "0"
           
            self.bindData()
        })
        
    }

    
    func getTotalPrice()->String{
        if let totalPrice = listOfProducts?.subtotalPrice {
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
        
        var returnedAmount = Double(amount) * 0.5
        
        /*if returnedAmount <= 0 {
            return 0
        }
        else {*/
        if returnedAmount > 0 && returnedAmount < 1 {
            return 1
        }else {
            return Int(returnedAmount)
       }
        
    }
    
    func deleteTheProductFromShopingCart(index:Int){
        
        listOfProducts?.lineItems?.remove(at: index+1)
        var draftOrderId = getShopingCartDraftOrderId()
        network?.putData(Draft(draft_order: listOfProducts), to: "admin/api/2024-04/draft_orders/\(draftOrderId).json", responseType: Draft.self){ success, error, response in
            
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
    
//    func clearAllProducts() {
//        guard var listOfProducts = listOfProducts, var lineItems = listOfProducts.lineItems, !lineItems.isEmpty else {
//            print("No products to clear or cart is empty")
//            print("listOfProducts: \(String(describing: listOfProducts))")
//            print("listOfProducts.lineItems: \(String(describing: listOfProducts?.lineItems))")
//            return
//        }
//        let firstItem = lineItems[0]
//        listOfProducts.lineItems = [firstItem]
//
//        let draftOrderId = getShopingCartDraftOrderId()
//
//        print("Updating draft order with only the first item: \(listOfProducts)")
//
//        network?.putData(Draft(draft_order: listOfProducts), to: "admin/api/2024-04/draft_orders/\(draftOrderId).json", responseType: Draft.self) { success, error, response in
//
//            if success {
//                self.listOfProducts = response?.draft_order
//                self.bindData()
//                print("Draft order successfully updated with only the first item retained")
//            } else {
//                print("Error updating draft order: \(String(describing: error))")
//            }
//        }
//    }
    
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
        var draftOrderId = getShopingCartDraftOrderId()
        network?.putData(Draft(draft_order: listOfProducts), to: "admin/api/2024-04/draft_orders/\(draftOrderId).json", responseType: Draft.self){ success, error, response in
            
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
        var draftOrderId = getShopingCartDraftOrderId()
        network?.putData(Draft(draft_order: listOfProducts), to: "admin/api/2024-04/draft_orders/\(draftOrderId).json", responseType: Draft.self){ success, error, response in
            
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
    
    func getProductById(productId: Int, completion: @escaping (ProductResponse?) -> Void) {
        let endpoint = "admin/api/2024-04/products/\(productId).json"
        NetworkHandler.instance.getData(endPoint: endpoint) { (result: ProductResponse?, error) in
            guard let result = result else {
                completion(nil)
                return
            }
            
            completion(result)
        }
    }
    
}
