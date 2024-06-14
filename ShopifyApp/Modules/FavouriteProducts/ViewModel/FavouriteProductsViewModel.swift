//
//  FavouriteProductsViewModel.swift
//  ShopifyApp
//
//  Created by Salma on 14/06/2024.
//

import Foundation

class FavouriteProductsViewModel{
    var favProducts : DraftOrder?
    
    
    func loadData() {
        NetworkHandler.instance.getData(endPoint: "admin/api/2024-04/draft_orders/978702532774.json") { (result: Draft?, error) in
        
            guard let result = result else {
                print("Error: \(error ?? "Unknown error")")
                return
            }
            print(result.draft_order?.lineItems)
            self.favProducts = result.draft_order
      
            var processedLineItems: [LineItem] = []
            for item in self.favProducts?.lineItems ?? [] {
               
                processedLineItems.append(item)
            }
            self.favProducts?.lineItems = processedLineItems
    
        }
   
    }
    
    func deleteFavProductFromFavDraftOrder(index:Int){
        
        favProducts?.lineItems?.remove(at: index+1)
        
        NetworkHandler.instance.putData(Draft(draft_order: favProducts), to: "admin/api/2024-04/draft_orders/978702532774.json", responseType: Draft.self){ success, error, response in
            
            if  success == true {
                self.favProducts = response?.draft_order
            }
            else{
                //print(error)
            }
        }
        
    }
    
    func getImageByIndex(index:Int)->String{
     
        return (favProducts?.lineItems?[index+1].properties?[0]["value"])!
    }
    
    func getProductsCount()-> Int {
        
        return ((favProducts?.lineItems?.count ?? 1) - 1)
        
    }

}



