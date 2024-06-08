//
//  ShopingCartViewModel.swift
//  ShopifyApp
//
//  Created by Naden on 07/06/2024.
//

import Foundation

class ShopingCartViewModel {
    
    var network : NetworkHandler?
    
    var listOfProducts : [DraftOrderLineItem]?
    
    var productImages : [String] = []
    
    var bindData:(()->Void) = {}
    
    var totalPrice : String = ""
    
    init(network: NetworkHandler) {
        self.network = network
        
    }
    
    func loadData(){
        
        network?.getData(endPoint: "admin/api/2024-04/draft_orders/978702565542.json", complitionHandler: { (result:Draft? , error) in
            print("enter")
            guard let result = result else {
                return
            }
            print(result)
            self.listOfProducts = result.draft_order?.lineItems
            
            /*for item in result.draft_order?.lineItems ?? [] {
                
                self.totalPrice += Int(item.price ?? "0") ?? 0
            }*/
            
            self.totalPrice = result.draft_order?.totalPrice ?? "0"
            self.productImages = result.draft_order?.note?.components(separatedBy: ",") ?? []
            self.bindData()
        })
        
    }

    
    func getTotalPrice()->String{
        return totalPrice
    }
    func getProductByIndex(index:Int) -> DraftOrderLineItem {
        
        return (listOfProducts?[index+1])!
    }
    
    func getImageByIndex(index:Int)->String{
        return productImages[index+1]
    }
    
    func getProductsCount()-> Int {
        
        return ((listOfProducts?.count ?? 1) - 1)
        
    }
    
}
