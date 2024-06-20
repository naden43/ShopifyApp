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
        print("in first init")
        self.selectedProduct = selectedProduct
          
        

        //self.favouriteProductsViewModel = FavouriteProductsViewModel()

    }
    func setFavViewModel(favouriteProductsViewModel: FavouriteProductsViewModel) {
        self.favouriteProductsViewModel = favouriteProductsViewModel
        print("favouriteProductsViewModel is set with \(favouriteProductsViewModel.getProductsCount()) products.")
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
                 print("yesss")
                 self.fetchDraftOrder(withId: draftOrderId, completion: completion)
             }
             
         }
     }

     private func fetchDraftOrder(withId id: String, completion: @escaping (Draft?, String?) -> Void) {
         let endPoint = "admin/api/2024-04/draft_orders/978702532774.json"
         DispatchQueue.global(qos: .background).async {
             NetworkHandler.instance.getData(endPoint: endPoint) { (response: Draft?, error) in
                 DispatchQueue.main.async {
                     if let response = response {
                         print("Response email is \(response.draft_order?.email ?? "No email")")
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
                print("imgsrccccccccccccccccccc\(imgSrc)")
                
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
        let endPoint = "admin/api/2024-04/draft_orders/978702532774.json"
        let updatedDraftOrder = Draft(draft_order: DraftOrder(lineItems:lineItems))
       // print("updatedDraftOrder\(updatedDraftOrder)")

        DispatchQueue.global(qos: .userInitiated).async {
            NetworkHandler.instance.putData(updatedDraftOrder, to: endPoint, responseType: Draft.self) { success, message, response in
                DispatchQueue.main.async {
                    if success {
                        print("Draft order updated successfully.")
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
        print("herrerer")
   
        guard let productId = selectedProduct?.id else {
            return false
        }
     
        
        print("dddddd \(favouriteProductsViewModel?.isProductInFavorites(productId: productId) ?? false)")
        return favouriteProductsViewModel?.isProductInFavorites(productId: productId) ?? false

    }

    func convertPriceByCurrency(price : Double) -> String {
        
        
        return CurrencyService.instance.calcThePrice(price: price)
    }
    
    func getCurrencyType() -> String {
        
        return CurrencyService.instance.getCurrencyType()
    }


    func deleteProductFromDraftOrder(productId: Int, completion: @escaping (Bool) -> Void) {
        guard var favProducts = favouriteProductsViewModel?.getFavProductsList() else {
            completion(false)
            return
        }
        
        if let index = favProducts.lineItems?.firstIndex(where: { $0.productId ?? 0 == productId }) {
            favProducts.lineItems?.remove(at: index)
            
            let endPoint = "admin/api/2024-04/draft_orders/978702532774.json"
            NetworkHandler.instance.putData(Draft(draft_order: favProducts), to: endPoint, responseType: Draft.self) { success, error, response in
                if success {
                    
                    self.favouriteProductsViewModel?.favProducts = response?.draft_order
                    print("trueeeeeeeeeeeeeeeeeeee")
                    completion(true)
                } else {print("falseeeeeeeeeeeeeeeeeeee")
                    completion(false)
                }
            }
        } else {
            completion(false)
        }
    }



}





 
