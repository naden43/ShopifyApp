//
//  HomeViewModel.swift
//  ShopifyApp
//
//  Created by Aya Mostafa on 04/06/2024.
//

import Foundation

protocol HomeViewModelProtocol {
    var bindToHomeViewController: (() -> Void)? { get set }
    func fetchBands (url : String)
    func getBrands() -> [SmartCollection]
    //   func getBrandId (id: Int) -> Int
    
}
    
    class HomeViewModel : HomeViewModelProtocol{
        var bindToProductViewController: (() -> Void)?
        private var brands : [SmartCollection]?
        var bindToHomeViewController: (() -> Void)?
        //  private var products :
        
        
        func fetchBands (url : String) {
            ApiServices.shared.fetchData(urlString: url){ (result: Result<Brands, Error>) in
                switch result {
                case .success(let data):
                    print("update")
                    print("update2")
                    self.brands = data.smartCollections
                    self.bindToHomeViewController?()
                    print("the count of brands is \(data.smartCollections.count)")
                case .failure(let error):
                    print("failed to fetch brands with error \(error.localizedDescription)")
                }
            }
        }
        
        func getBrands() -> [SmartCollection] {
            guard let brands = brands else {
                return []
            }
            return brands
        }
        
    }

