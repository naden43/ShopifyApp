//
//  ProductDetailsViewModel.swift
//  ShopifyApp
//
//  Created by Salma on 11/06/2024.
//

import Foundation

class ProductDetailsViewModel {
    var selectedProduct: Product?
    var destination: Bool?
    private var favouriteProductsViewModel : FavouriteProductsViewModel?
    var bindToProductViewController: (() -> Void)?
    

    init(selectedProduct: Product){
        self.selectedProduct = selectedProduct
          
    }
    func setFavViewModel(favouriteProductsViewModel: FavouriteProductsViewModel) {
        self.favouriteProductsViewModel = favouriteProductsViewModel
        print("favouriteProductsViewModel is set with \(favouriteProductsViewModel.getProductsCount()) products.")
    }
    func getFavViewModel() -> FavouriteProductsViewModel?{
        return favouriteProductsViewModel
    }
    
    func getDraftOrder(completion: @escaping (Draft?, String?) -> Void) {
         DispatchQueue.global(qos: .background).async {
             let userDefaultsManager = UserDefaultsManager.shared
             let customerInfo = userDefaultsManager.getCustomer()
             if self.destination == true{
                 guard let draftOrderId = customerInfo.shoppingCartDraftOrderId else {
                     DispatchQueue.main.async {
                         completion(nil, "No shopping cart draft order ID found.")
                     }
                     return
                 }
                 self.fetchDraftOrder(withId: draftOrderId, completion: completion)
             }else{
                 guard let draftOrderId = customerInfo.favProductsDraftOrderId else {
                     DispatchQueue.main.async {
                         completion(nil, "No shopping cart draft order ID found.")
                     }
                     return
                 }
                 self.fetchDraftOrder(withId: draftOrderId, completion: completion)
             }
             
         }
     }

     private func fetchDraftOrder(withId id: String, completion: @escaping (Draft?, String?) -> Void) {
         let endPoint = "admin/api/2024-04/draft_orders/\(id).json"
         DispatchQueue.global(qos: .background).async {
             NetworkHandler.instance.getData(endPoint: endPoint) { (response: Draft?, error) in
                 DispatchQueue.main.async {
                     if let response = response {
                         completion(response, nil)
                     } else {
                         completion(nil, error)
                     }
                 }
             }
         }
     }
    func addSelectedProductToDraftOrder( completion: @escaping (Bool, String?) -> Void) {
        getDraftOrder { response, error in
            guard let response = response, let selectedProduct = self.selectedProduct else {
                DispatchQueue.main.async {
                    completion(false, error ?? "Failed to fetch draft order or selected product is nil.")
                }
                return
            }
            
            var newLineItems = response.draft_order?.lineItems ?? []
            
            if let variantId = selectedProduct.variants?.first?.id,
               let imgSrc = selectedProduct.images?.first?.src {
                let properties: [[String: String]] = [["name": "image_url", "value": imgSrc]]
                let newLineItem = LineItem(variantId: variantId, quantity: 1, properties: properties)
                
                newLineItems.append(newLineItem)
                
                self.updateDraftOrder(draftOrderId: response.draft_order?.id ?? 0, lineItems: newLineItems) { success, error in
                    DispatchQueue.main.async {
                        completion(success, error)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    completion(false, "Selected product has no variants or image source.")
                }
            }
        }
    }
  
    private func updateDraftOrder(draftOrderId: Int64, lineItems: [LineItem], completion: @escaping (Bool, String?) -> Void) {
        let endPoint = "admin/api/2024-04/draft_orders/\(draftOrderId).json"
        let updatedDraftOrder = Draft(draft_order: DraftOrder(lineItems:lineItems))

        DispatchQueue.global(qos: .userInitiated).async {
            NetworkHandler.instance.putData(updatedDraftOrder, to: endPoint, responseType: Draft.self) { success, message, response in
                DispatchQueue.main.async {
                    if success {
                        completion(true, "Draft order updated successfully.")
                    } else {
                        let errorMessage = message ?? "Unknown error"
                        print("Failed to update draft order. Error: \(errorMessage)")
                        completion(false, errorMessage)
                    }
                }
            }
        }
    }
    
    func isProductInFavorites() -> Bool {
   
        guard let productId = selectedProduct?.id else {
            return false
        }
     
        print(productId)

        return favouriteProductsViewModel?.isProductInFavorites(productId: productId) ?? false

    }

    func convertPriceByCurrency(price : Double) -> String {
        
        
        return CurrencyService.instance.calcThePrice(price: price)
    }
    
    func getCurrencyType() -> String {
        
        return CurrencyService.instance.getCurrencyType()
    }


    func deleteProductFromFavDraftOrder(productId: Int, completion: @escaping (Bool) -> Void) {
        let favDraftOrder = UserDefaultsManager.shared.getCustomer().favProductsDraftOrderId!
        
        guard var favProducts = favouriteProductsViewModel?.getFavProductsList() else {
            completion(false)
            return
        }
        
        if let index = favProducts.lineItems?.firstIndex(where: { $0.productId ?? 0 == productId }) {
            favProducts.lineItems?.remove(at: index)
            
            let endPoint = "admin/api/2024-04/draft_orders/\(favDraftOrder).json"
            NetworkHandler.instance.putData(Draft(draft_order: favProducts), to: endPoint, responseType: Draft.self) { success, error, response in
                if success {
                    
                    self.favouriteProductsViewModel?.favProducts = response?.draft_order
                    completion(true)
                } else {
                 
                    completion(false)
                }
            }
        } else {
            completion(false)
        }
    }
    func loadFavorites(completion: @escaping () -> Void) {
          favouriteProductsViewModel?.loadData(completion: completion)
    }
    
    func checkIfProductExists(productId: Int, completion: @escaping (Bool) -> Void) {
        getDraftOrder { draft, error in
            guard let draft = draft else {
                completion(false)
                return
            }
            
            let exists = draft.draft_order?.lineItems?.contains { $0.productId ?? 0 == productId } ?? false
         
            completion(exists)
        }
    }
    
    
    func increaseQuantityOfExistingProduct(productId: Int, completion: @escaping (Bool, String?) -> Void) {
        getDraftOrder { draft, error in
            guard let draft = draft, var lineItems = draft.draft_order?.lineItems else {
                completion(false, "Draft order not found or no line items.")
                return
            }
            
            if let index = lineItems.firstIndex(where: { $0.productId ?? 0 == productId }) {
                lineItems[index].quantity? += 1
                
                self.updateDraftOrder(draftOrderId: draft.draft_order?.id ?? 0, lineItems: lineItems) { success, message in
                    completion(success, message)
                }
            } else {
                completion(false, "Product not found in draft order.")
            }
        }
    }



}
