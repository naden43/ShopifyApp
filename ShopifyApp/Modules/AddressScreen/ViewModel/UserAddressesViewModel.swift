//
//  UserAddressesViewModel.swift
//  ShopifyApp
//
//  Created by Naden on 03/06/2024.
//

import Foundation



protocol EditAddressScreenRequirment{
    
    func getAddress()->Address?
    
}

class UserAddressesViewModel : EditAddressScreenRequirment{
    
   
    
    

   private var addressesList : [Address]?
    
    var selectedAddress : Address?
    
   private var network : NetworkHandler?
    
    var bindAddresses : (()-> Void) = {}
    
    var faildDeletion : (()->Void) = {}
    
    var setDefaultResult : ((String) -> Void) = {result in }
    
    var bindError : (()->Void) = {}
    
    //var FaildDefault : (() -> Void) = {}

    
    init(network: NetworkHandler) {
        self.network = network
    }
    
    
    func getAddresesCount() -> Int {
        
        return addressesList?.count ?? 0
    }
    
    func getAddressByIndex(index:Int) ->  Address{
        
        return (addressesList?[index])!
    }
    
    private func getCustomerId() -> Int {
        
        return UserDefaultsManager.shared.getCustomer().id ?? 0
    }
    
    
    func loadData() {
        
        
        let customerId = getCustomerId()
        network?.getData(endPoint: "admin/api/2024-04/customers/\(customerId)/addresses.json", complitionHandler: { (result:UserAddresses? , error) in
            
            guard let result = result else {
                self.bindError()
                return
            }
            
            self.addressesList = result.addresses
            self.bindAddresses()
        
        })
        
    }
    
    
    func setAsDefaultAddress(index:Int){
        
        let address = addressesList?[index]
        
        if address?.default == true {
            
            setDefaultResult(" it is Already a Default Address")
        }
        else{
            
            network?.setDefaultAddress(endPoint: "admin/api/2024-04/customers/\(address?.customerId ?? 0 )/addresses/\(address?.id ?? 0 )/default.json", complition: { result in
                print(result)
                if result == true {
                    
                    self.setDefaultResult("Default Address Changed Successfully")
                    self.loadData()
                }
                else {
                    
                    self.setDefaultResult("Some server Error Try Again Later !!")
                }
            })
        }
        
        
    }
    
    
    func getAddress() -> Address? {
        return selectedAddress
    }
    
    
    func deleteAddress(index:Int){
        
        let address = addressesList?[index] ?? Address()
        network?.deleteAddress(endPoint: "admin/api/2024-04/customers/\(address.customerId ?? 0 )/addresses/\(address.id ?? 0 ).json",  completion: { result in
            
            DispatchQueue.main.async {
                if result == true {
                    
                    self.addressesList?.remove(at: index)
                    self.bindAddresses()
                    
                }
                else {
                    self.faildDeletion()
                }
            }
           
            
        })
        
    }
    
    
}
