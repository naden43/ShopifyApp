//
//  AddAddressViewModel.swift
//  ShopifyApp
//
//  Created by Naden on 02/06/2024.
//

import Foundation

class AddAddressViewModel {
    
    
    var countries = ["Egypt"]
    var cities = ["Cairo" , "Giza" , "Ismalia" , "Alexandria"]
    
    var missedData : (()->Void) = {}
    
    var inValidPhone : (() -> Void) = {}
    
    var validationManager : NetworkHandler?
    
    init(validationManager : NetworkHandler){
        self.validationManager = validationManager
    }
    
    func getCountriesNumber() -> Int{
        return countries.count
    }
    
    func getCitiesNumber() -> Int{
        return cities.count
    }
    
    func getcCountryByIndex(index:Int) -> String{
        return countries[index]
    }
    
    func getCityByIndex(index:Int) -> String {
        return cities[index]
    }
    
    func performAddAddress(address:ReturnAddress){
        
        let validEntry = validateAddress(address: address)
        
        if validEntry {
            // check phone number validation to specific country
           // validatePhoneNumber(phoneNumber: address.phone!)
            /*validationManager?.addAddress(address: address, completionHandler: { result in
                print(result)
            })*/
            performAdd(address: address)
        }
        else{
            missedData()
        }
        
    }
    
    
    
    func performAdd(address:ReturnAddress) {
        
        /*validationManager?.postAddress2(address, completion: { result, error in
            
            print(result)
            print(error)
        })*/
        
        /*validationManager?.postData(AddressObject(address: address), to: "admin/api/2024-04/customers/7864239587494/addresses.json", responseType: CustomAddress.self, completion: { success, error, response in
            print(success)
            print(error)
            print(response)
            
        })*/
        
        
        var addresss = CustomerAddress(address: CustomerAddress.Address(address1: address.address1 ?? "", city: address.city ?? "", province: "", country: address.country ?? "", zip: "12342"))
        
        
        validationManager?.postData(addresss, to: "admin/api/2024-04/customers/7864239587494/addresses.json", responseType: CustomAddress.self , completion: { success, error, response in
            
            print(success)
            print(error)
            print(response)
            
        })
        
    }
    
    
    func validateAddress(address:ReturnAddress) -> Bool {
         
        if (address.address1 == "") || (address.first_name == "") || (address.last_name == "") || (address.phone == "") {
            
            return false
        }
        else {
            return true
        }
    }
    
}
