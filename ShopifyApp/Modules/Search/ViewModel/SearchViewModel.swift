//
//  SearchViewModel.swift
//  ShopifyApp
//
//  Created by Salma on 15/06/2024.
//

/*

import Foundation

class SearchViewModel {
    var brandsProductsListIds: [Int] = []
    var categoriesListIds: [Int] = []
    var products: [Product] = []
    var filteredProducts: [Product] = []
    
 /*   func fetchCollectionAndCategoryIDs(completion: @escaping (Bool) -> Void) {
        let smartCollectionsEndpoint = "admin/api/2024-04/smart_collections.json"
        let categoriesEndpoint = "admin/api/2024-04/custom_collections.json"
        
        let dispatchGroup = DispatchGroup()
        var success = true
        
        // Fetch smart collections
              dispatchGroup.enter()
         NetworkHandler.instance.getData(endPoint: smartCollectionsEndpoint) { (collections: Brands?, errorMessage) in
         defer {
         dispatchGroup.leave()
         }
         
         if let collections = collections {
         self.brandsProductsListIds = collections.smartCollections.map { $0.id }
         print("Smart Collections IDs: \(self.brandsProductsListIds)")
         } else {
         print("Error fetching smart collections: \(errorMessage ?? "Unknown error")")
         success = false
         }
         }
         
         
         // Fetch categories
         dispatchGroup.enter()
         NetworkHandler.instance.getData(endPoint: categoriesEndpoint) { (categories: Categories?, errorMessage) in
         defer {
         dispatchGroup.leave()
         }
         
         if let categories = categories {
         self.categoriesListIds = categories.customCollections.map { $0.id }
         print("Categories IDs: \(self.categoriesListIds)")
         } else {
         print("Error fetching categories: \(errorMessage ?? "Unknown error")")
         success = false
         }
         }
         
         // Notify completion when both requests finish
         dispatchGroup.notify(queue: .main) {
         if success {
         self.fetchProducts(completion: completion)
         } else {
         completion(false)
         }
         }
         }
         */
     func fetchProducts(completion: @escaping (Bool) -> Void) {
            
            let productsEndpoint = "admin/api/2024-04/products.json"
            
            NetworkHandler.instance.getData(endPoint: productsEndpoint) { (productsResponse: Products?, errorMessage) in
                if let productsResponse = productsResponse {
                    self.products = productsResponse.products
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


*/

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

