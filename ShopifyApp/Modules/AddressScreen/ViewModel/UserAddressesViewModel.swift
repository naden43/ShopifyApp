//
//  UserAddressesViewModel.swift
//  ShopifyApp
//
//  Created by Naden on 03/06/2024.
//

import Foundation

class UserAddressesViewModel{
    

    var addressesList : [Address]?
    
    var network : NetworkHandler?
    
    var bindAddresses : (()-> Void) = {}
    
    init(network: NetworkHandler) {
        self.network = network
    }
    
    
    func getAddresesCount() -> Int {
        
        return addressesList?.count ?? 0
    }
    
    func getAddressByIndex(index:Int) ->  Address{
        
        return (addressesList?[index])!
    }
    
    func loadData() {
        
        network?.getAddresses(complitionHandler: { result in
            
            DispatchQueue.main.async {
                self.addressesList = result
                self.bindAddresses()
            }
            
        })
        
    }
    
    
}
