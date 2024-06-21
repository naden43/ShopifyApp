//
//  SearchViewModel.swift
//  ShopifyApp
//
//  Created by Salma on 15/06/2024.
//



import Foundation

class SearchViewModel {
    var products: [Product] = []
    var filteredProducts: [Product] = []
    
    func fetchProducts(completion: @escaping (Bool) -> Void) {
        let productsEndpoint = "admin/api/2024-04/products.json"
        
        NetworkHandler.instance.getData(endPoint: productsEndpoint) { (productsResponse: Products?, errorMessage) in
            if let productsResponse = productsResponse {
                self.products = productsResponse.products
                self.filteredProducts = productsResponse.products // Initialize with all products
                print("Fetched \(self.products.count) products")
                completion(true)
            } else {
                print("Error fetching products: \(errorMessage ?? "Unknown error")")
                completion(false)
            }
        }
    }
    
    func filterProducts(with query: String) {
        if query.isEmpty {
            filteredProducts = products
        } else {
            filteredProducts = products.filter { $0.title?.lowercased().contains(query.lowercased()) == true }
        }
    }
}


