//
//  AddAddressInfoViewController.swift
//  ShopifyApp
//
//  Created by Naden on 30/05/2024.
//

import UIKit

class AddAddressInfoViewController: UIViewController , UIPickerViewDelegate , UIPickerViewDataSource {
 
    

    @IBOutlet weak var phoneNumberTxtField: UITextField!
    @IBOutlet weak var address1TxtField: UITextField!
    @IBOutlet weak var cityPicker: UIPickerView!
    @IBOutlet weak var firstNameTxtField: UITextField!
    @IBOutlet weak var countryPicker: UIPickerView!
    @IBOutlet weak var lastNameTxtField: UITextField!
    
    var viewModel:AddAddressViewModel?
    var selectedCity:String?
    var selectedCountry:String?
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    }
    

    @IBAction func backToAddressesList(_ sender: Any) {
        
        dismiss(animated: true)
    }
   
    @IBAction func performAddAddress(_ sender: Any) {
        
        
        viewModel?.performAddAddress(address: collectDataFromUI())
        
    }
    
    func collectDataFromUI()-> Address{
        
        var address = Address()
        
        address.city = selectedCity
        address.country = selectedCountry
        address.address1 = address1TxtField.text
        address.first_name = firstNameTxtField.text
        address.last_name = lastNameTxtField.text
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
            
            return viewModel?.getcCountryByIndex(index: row)
        }
        else {
            return viewModel?.getCityByIndex(index: row)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == countryPicker {
            
            selectedCountry = viewModel?.getcCountryByIndex(index: row)
        }
        else {
            selectedCity = viewModel?.getCityByIndex(index: row)
        }
    }
    
}

