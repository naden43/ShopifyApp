//
//  FavouriteProductsViewModel.swift
//  ShopifyApp
//
//  Created by Salma on 14/06/2024.
//

/*import Foundation

class FavouriteProductsViewModel {
    var favProducts: DraftOrder?
    
    func getFavouriteDraftOrderId() -> String {
        
        return UserDefaultsManager.shared.getCustomer().favProductsDraftOrderId ?? ""
    }
    
    
    func loadData(completion: @escaping () -> Void) {
        
        let favDraftOrder = getFavouriteDraftOrderId()
        NetworkHandler.instance.getData(endPoint: "admin/api/2024-04/draft_orders/\(favDraftOrder).json") { (result: Draft?, error) in
            guard let result = result else {
                return
            }
            print( "self.getProductsCount()\(self.getProductsCount())")
            self.favProducts = result.draft_order
            completion()
        }
    }

    func deleteFavProductFromFavDraftOrder(index: Int, completion: @escaping (Bool) -> Void) {
        favProducts?.lineItems?.remove(at: index + 1)
        let favDraftOrder = getFavouriteDraftOrderId()
        NetworkHandler.instance.putData(Draft(draft_order: favProducts), to: "admin/api/2024-04/draft_orders/\(favDraftOrder).json", responseType: Draft.self) { success, error, response in
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
        print("favProducts\(productId)")
     
        guard let favProducts = favProducts?.lineItems else {
            return false
        }        
        return favProducts.contains { $0.productId ?? 0 == productId }
    }
    
    func getFavProductsList() -> DraftOrder? {
        print("favproductlist\(self.favProducts)")
        return self.favProducts
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
    
    func getTheRemainingOfFavourites(){
        if favProducts?.lineItems.count > 2{
            // skip  the first two
        }
        // print no more
    }
}

*/

import Foundation

class FavouriteProductsViewModel {
    var favProducts: DraftOrder?
    
    func getFavouriteDraftOrderId() -> String {
        return UserDefaultsManager.shared.getCustomer().favProductsDraftOrderId ?? ""
    }
    
    func loadData(completion: @escaping () -> Void) {
        let favDraftOrder = getFavouriteDraftOrderId()
        NetworkHandler.instance.getData(endPoint: "admin/api/2024-04/draft_orders/\(favDraftOrder).json") { (result: Draft?, error) in
            guard let result = result else {
                return
            }
            self.favProducts = result.draft_order
            completion()
        }
    }

    func deleteFavProductFromFavDraftOrder(index: Int, completion: @escaping (Bool) -> Void) {
        guard var lineItems = favProducts?.lineItems, index < lineItems.count else {
            completion(false)
            return
        }
        lineItems.remove(at: index)
        favProducts?.lineItems = lineItems
        let favDraftOrder = getFavouriteDraftOrderId()
        NetworkHandler.instance.putData(Draft(draft_order: favProducts), to: "admin/api/2024-04/draft_orders/\(favDraftOrder).json", responseType: Draft.self) { success, error, response in
            if success {
                self.favProducts = response?.draft_order
                completion(true)
            } else {
                completion(false)
            }
        }
    }

    func getImageByIndex(index: Int) -> String? {
        guard let lineItems = favProducts?.lineItems, index < lineItems.count else {
            return nil
        }
        return lineItems[index].properties?.first?["value"]
    }

    func getProductsCount() -> Int {
        return favProducts?.lineItems?.count ?? 0
    }

    func isProductInFavorites(productId: Int) -> Bool {
        guard let favProducts = favProducts?.lineItems else {
            return false
        }
        return favProducts.contains { $0.productId ?? 0 == productId }
    }
    
    func getFavProductsList() -> DraftOrder? {
        return self.favProducts
    }

    func getProductById(productId: Int, completion: @escaping (ProductResponse?) -> Void) {
        let endpoint = "admin/api/2024-04/products/\(productId).json"
        NetworkHandler.instance.getData(endPoint: endpoint) { (result: ProductResponse?, error) in
            completion(result)
        }
    }

    func getTheRemainingOfFavourites() -> [LineItem]? {
        guard let lineItems = favProducts?.lineItems, lineItems.count > 2 else {
            return nil
        }
        return Array(lineItems.dropFirst(3))
    }
    
    func getRemainingProductsCount() -> Int {
        return getTheRemainingOfFavourites()?.count ?? 0
    }
}





