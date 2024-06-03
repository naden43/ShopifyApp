//
//  AddAddressInfoViewController.swift
//  ShopifyApp
//
//  Created by Naden on 30/05/2024.
//

import UIKit

class AddAddressInfoViewController: UIViewController {

    @IBOutlet weak var phoneNumberTxtField: UITextField!
    @IBOutlet weak var address1TxtField: UITextField!
    @IBOutlet weak var cityPicker: UIPickerView!
    @IBOutlet weak var firstNameTxtField: UITextField!
    @IBOutlet weak var countryPicker: UIPickerView!
    @IBOutlet weak var lastNameTxtField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    
        // Do any additional setup after loading the view.
    }
    

    @IBAction func backToAddressesList(_ sender: Any) {
        
        dismiss(animated: true)
    }
   
    @IBAction func performAddAddress(_ sender: Any) {
    }
    
}
