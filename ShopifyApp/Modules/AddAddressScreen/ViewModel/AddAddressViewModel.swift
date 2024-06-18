//
//  AddAddressViewModel.swift
//  ShopifyApp
//
//  Created by Naden on 02/06/2024.
//

import Foundation

class AddAddressViewModel {
    
    
    var countries = ["Egypt"]
    var cities : [String] = []//["Cairo" , "Giza" , "Ismalia" , "Alexandria"]
    
    var missedData : (()->Void) = {}
    
    var inValidPhone : (() -> Void) = {}
    
    var network : NetworkHandler?
    
    var countriesFromJson:Countries?
    
    var signalCompleteOperation : (()->Void) = {}
    
    
    
    init(validationManager : NetworkHandler){
        self.network = validationManager
    }
    
    func getCountriesNumber() -> Int{
        return countriesFromJson?.countries.count ?? 0
    }
    
    func getCitiesNumber() -> Int{
        return cities.count
    }
    
    func getcCountryByIndex(index:Int) -> String{
        return countriesFromJson?.countries[index].name ?? ""
    }
    
    func getCityByIndex(index:Int) -> String {
        
        if index >= cities.count {
            return ""
        }
        else{
            return cities[index]
        }
    }
    
    func changeTheSelectedCountry(index:Int){
        cities = countriesFromJson?.countries[index].cities ?? []
    }
    
    func parseCountries(url:URL) {
        
        do{
            let data =  try Data(contentsOf: url)
            let countries = try JSONDecoder().decode(Countries.self, from: data)
            countriesFromJson = countries
            cities = countriesFromJson?.countries[0].cities ?? []
            
        }
        catch let error {
            print(error)
        }
    }
    
    private func getCustomerId() -> Int {
        
        return UserDefaultsManager.shared.getCustomer().id ?? 0
    }
    
    func editAddress(address:Address){
        
        let customerId = getCustomerId()
        network?.putData(CustomerAddress(address: address)
                         , to: "admin/api/2024-04/customers/\(customerId)/addresses/\(address.id ?? 0 ).json", responseType:  CustomAddress.self , completion: { [weak self] success, error, result in
            
            if success == true {
                self?.signalCompleteOperation()
            }
            else {
                print(error)
            }
        })
    }
    
    func getIndexToCountryByName(countryName:String)->Int {
        
        let countries = countriesFromJson?.countries ?? []
        for (index, country) in countries.enumerated() {
            if country.name == countryName {
                    print("here")
                    return index
                }
        }
        return 0
    }
    
    func getIndexToCityByName(cityName:String)->Int {
        
        for (index, country) in cities.enumerated() {
                if country == cityName {
                    return index
                }
        }
        return 0
        
    }
    
    func performAddAddress(address:Address){
        
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
    
    
    
    func performAdd(address:Address) {
        
        /*validationManager?.postAddress2(address, completion: { result, error in
            
            print(result)
            print(error)
        })*/
        
        /*validationManager?.postData(AddressObject(address: address), to: "admin/api/2024-04/customers/7864239587494/addresses.json", responseType: CustomAddress.self, completion: { success, error, response in
            print(success)
            print(error)
            print(response)
            
        })*/
        
        
        
        let customerId = getCustomerId()
        network?.postData(CustomerAddress(address: address), to: "admin/api/2024-04/customers/\(customerId)/addresses.json", responseType: CustomAddress.self , completion: { [weak self] success, error, response in
            
            self?.signalCompleteOperation()
            
        })
        
    }
    
    
    func validateAddress(address:Address) -> Bool {
         
        if (address.address1 == "") || (address.firstName == "") || (address.lastName == "") || (address.phone == "") {
            
            return false
        }
        else {
            return true
        }
    }
    
}
