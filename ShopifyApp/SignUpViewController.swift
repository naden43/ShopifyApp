//
//  SignUpViewController.swift
//  ShopifyApp
//
//  Created by Salma on 03/06/2024.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var secondNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var conformPasswordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func signUpBtn(_ sender: Any) {
        guard let firstName = firstNameTextField.text, !firstName.isEmpty,
              let secondName = secondNameTextField.text, !secondName.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
              let mobile = mobileTextField.text, !mobile.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let conformPassword = conformPasswordTextField.text, !conformPassword.isEmpty else {
            showError("All fields are required.")
            return
        }
        
        guard password == conformPassword else {
            showError("Passwords do not match.")
            return
        }
        
        let customerData = [
            "firstName": firstName,
            "secondName": secondName,
            "email": email,
            "mobile": mobile,
            "password": password
          
        ]
        
        NetworkHandler.shared.postCustomerData(customerData) { success, message in
            DispatchQueue.main.async {
                if success {
                    self.showSuccess("Signup successful!")
                } else {
                    self.showError(message ?? "Signup failed")
                }
            }
        }
    }

    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showSuccess(_ message: String) {
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
