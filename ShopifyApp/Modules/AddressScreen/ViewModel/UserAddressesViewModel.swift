//
//  UserAddressesViewModel.swift
//  ShopifyApp
//
//  Created by Naden on 03/06/2024.
//

import Foundation

class UserAddressesViewModel{
    

    var addressesList : [ReturnAddress]?
    
    var network : NetworkHandler?
    
    var bindAddresses : (()-> Void) = {}
    
    var faildDeletion : (()->Void) = {}
    
    var setDefaultResult : ((String) -> Void) = {result in }
    
    //var FaildDefault : (() -> Void) = {}

    
    init(network: NetworkHandler) {
        self.network = network
    }
    
    
    func getAddresesCount() -> Int {
        
        return addressesList?.count ?? 0
    }
    
    func getAddressByIndex(index:Int) ->  ReturnAddress{
        
        return (addressesList?[index])!
    }
    
    func loadData() {
        
        /*network?.getAddresses(complitionHandler: { result in
            
            DispatchQueue.main.async {
                self.addressesList = result
                self.bindAddresses()
            }
            
        })*/
        
        network?.getData(endPoint: "admin/api/2024-04/customers/7866530955430/addresses.json", complitionHandler: { (result:UserAddresses? , error) in
            
            guard let result = result else {
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
            
            network?.setDefaultAddress(endPoint: "admin/api/2024-04/customers/\(address?.customer_id ?? 0 )/addresses/\(address?.id ?? 0 )/default.json", complition: { result in
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
    
    func deleteAddress(index:Int){
        
        let address = addressesList?[index] ?? ReturnAddress()
        network?.deleteAddress(endPoint: "admin/api/2024-04/customers/\(address.customer_id ?? 0 )/addresses/\(address.id ?? 0 ).json",  completion: { result in
            
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
