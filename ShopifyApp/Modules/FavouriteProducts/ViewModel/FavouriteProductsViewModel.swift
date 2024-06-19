//
//  FavouriteProductsViewModel.swift
//  ShopifyApp
//
//  Created by Salma on 14/06/2024.
//

import Foundation
class FavouriteProductsViewModel {
    var favProducts: DraftOrder?
    


    func loadData(completion: @escaping () -> Void) {
        NetworkHandler.instance.getData(endPoint: "admin/api/2024-04/draft_orders/978702532774.json") { (result: Draft?, error) in
            print("inside")
            guard let result = result else {
                // Handle error if needed
                return
            }
            print( "self.getProductsCount()\(self.getProductsCount())")
            self.favProducts = result.draft_order
            completion()
        }
    }

    func deleteFavProductFromFavDraftOrder(index: Int, completion: @escaping (Bool) -> Void) {
        favProducts?.lineItems?.remove(at: index + 1)
        
        NetworkHandler.instance.putData(Draft(draft_order: favProducts), to: "admin/api/2024-04/draft_orders/978702532774.json", responseType: Draft.self) { success, error, response in
            if success {
                self.favProducts = response?.draft_order
                completion(true)
            } else {
                completion(false)
            }
        }
    }

    func getImageByIndex(index: Int) -> String? {
        return favProducts?.lineItems?[index + 1].properties?.first?["value"]
    }

    func getProductsCount() -> Int {
        return (favProducts?.lineItems?.count ?? 1) - 1
    }

    func isProductInFavorites(productId: Int) -> Bool {
        print("maiiaiai")
        print("favProducts\(favProducts?.lineItems?.count)")
        print("favProducts?.lineItems?.count \(favProducts?.lineItems?.count)")
     
        guard let favProducts = favProducts?.lineItems else {
            return false
        }
        print("in isProductInFavorites \(favProducts.contains { $0.productId ?? 0 == productId })")
        
        return favProducts.contains { $0.productId ?? 0 == productId }
    }
    
    func getFavProductsList() -> DraftOrder?{
        print("favproductlist\(self.favProducts)")
        return self.favProducts
    }
}






