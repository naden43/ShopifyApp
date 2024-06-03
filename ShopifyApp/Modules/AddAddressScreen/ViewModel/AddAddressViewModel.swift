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
    
    func performAddAddress(address:Address){
        
        let validEntry = validateAddress(address: address)
        
        if validEntry {
            // check phone number validation to specific country
           // validatePhoneNumber(phoneNumber: address.phone!)
            /*validationManager?.addAddress(address: address, completionHandler: { result in
                print(result)
            })*/
        }
        else{
            missedData()
        }
        
    }
    
    
    
    func performAdd() {
        
    }
    
    
    func validateAddress(address:Address) -> Bool {
         
        if (address.address1 == "") || (address.first_name == "") || (address.last_name == "") || (address.phone == "") {
            
            return false
        }
        else {
            return true
        }
    }
    
}
