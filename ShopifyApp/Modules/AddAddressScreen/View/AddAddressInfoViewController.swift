//
//  AddAddressInfoViewController.swift
//  ShopifyApp
//
//  Created by Naden on 30/05/2024.
//

import UIKit

class AddAddressInfoViewController: UIViewController , UIPickerViewDelegate , UIPickerViewDataSource {
 
    
    
    @IBOutlet weak var performActionOnAddressButton: UIButton!
    
    var allAddressesScreenViewModel:EditAddressScreenRequirment?
    @IBOutlet weak var phoneNumberTxtField: UITextField!
    @IBOutlet weak var address1TxtField: UITextField!
    @IBOutlet weak var cityPicker: UIPickerView!
    @IBOutlet weak var firstNameTxtField: UITextField!
    @IBOutlet weak var countryPicker: UIPickerView!
    @IBOutlet weak var lastNameTxtField: UITextField!
    
    var viewModel:AddAddressViewModel?
    var selectedCity:String?
    var selectedCountry:String?
    var editMode:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        guard let url = Bundle.main.url(forResource: "countries", withExtension: "json") else {
            print("error")
            return
        }
        
        
        

        viewModel = AddAddressViewModel(validationManager: NetworkHandler.instance)
        
        
        
        
        
        countryPicker.delegate = self
        cityPicker.delegate = self
        countryPicker.dataSource = self
        cityPicker.dataSource = self
        
        selectedCity = viewModel?.getCityByIndex(index: 0)
        selectedCountry = viewModel?.getcCountryByIndex(index: 0)
        viewModel?.missedData = { [weak self] in
            
            let alert = UIAlertController(title: "AddAddress", message: "some of data missed please fil required data", preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "ok", style: .default , handler: { UIAlertAction in
                
            }))
            
            self?.present(alert, animated: true)
        }
        
        viewModel?.inValidPhone = { [weak self] in
            
            let alert = UIAlertController(title: "AddAddress", message: "phone number is not valid please check it again ", preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "ok", style: .default , handler: { UIAlertAction in
                
            }))
            
            self?.present(alert, animated: true)
            
        }
        
        viewModel?.signalCompleteOperation = {
            self.dismiss(animated: true)
        }
        
        viewModel?.parseCountries(url: url)
        
        
        if allAddressesScreenViewModel != nil {
            editMode = true
            let address = allAddressesScreenViewModel?.getAddress()
            performActionOnAddressButton.setTitle("Edit Address", for: .normal)
            let countryPlaceInpicker = viewModel?.getIndexToCountryByName(countryName: address?.country ??  "") ?? 0
            countryPicker.selectRow(countryPlaceInpicker, inComponent: 0, animated: true)
            print(address?.country)
            viewModel?.changeTheSelectedCountry(index: countryPlaceInpicker)
            cityPicker.reloadAllComponents()
            let cityPlaceInPicker = viewModel?.getIndexToCityByName(cityName: address?.city ?? "") ?? 0
            print(cityPlaceInPicker)
            print(address?.city)
            cityPicker.selectRow(cityPlaceInPicker, inComponent: 0, animated: true)
            
            firstNameTxtField.text = address?.firstName ?? ""
            lastNameTxtField.text = address?.lastName ?? ""
            address1TxtField.text = address?.address1 ?? ""
            phoneNumberTxtField.text = address?.phone ?? ""
            
        }
    
    }
    

    @IBAction func backToAddressesList(_ sender: Any) {
        
        dismiss(animated: true)
    }
   
    @IBAction func performAddAddress(_ sender: Any) {
        
        if editMode == false {
            viewModel?.performAddAddress(address: collectDataFromUI())
        }
        else {
            viewModel?.editAddress(address: collectDataFromUIToExistAddress())
        }
        
    }
    
    func collectDataFromUIToExistAddress() -> Address {
        var address = allAddressesScreenViewModel?.getAddress()
        
        address?.city = selectedCity
        address?.country = selectedCountry
        address?.address1 = address1TxtField.text
        address?.firstName = firstNameTxtField.text
        address?.lastName = lastNameTxtField.text
        address?.phone = phoneNumberTxtField.text
     
        return address!
    }
    
    func collectDataFromUI()-> Address{
        
        var address = Address()
        
        address.city = selectedCity
        address.country = selectedCountry
        address.address1 = address1TxtField.text
        address.firstName = firstNameTxtField.text
        address.lastName = lastNameTxtField.text
        address.phone = phoneNumberTxtField.text
        
        return address
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == countryPicker {
            return viewModel?.getCountriesNumber() ?? 0
        }
        else {
            return viewModel?.getCitiesNumber() ?? 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == countryPicker {
            
            //viewModel?.changeTheSelectedCountry(index: row)
            //pickerView.reloadAllComponents()
            return viewModel?.getcCountryByIndex(index: row)
            
        }
        else {
            return viewModel?.getCityByIndex(index: row)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == countryPicker {
            
            selectedCountry = viewModel?.getcCountryByIndex(index: row)
            viewModel?.changeTheSelectedCountry(index: row)
            cityPicker.reloadAllComponents()
        }
        else {
            selectedCity = viewModel?.getCityByIndex(index: row)
        }
    }
    
}

