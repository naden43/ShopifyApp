//
//  SignUpViewController.swift
//  ShopifyApp
//
//  Created by Salma on 03/06/2024.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var secondNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var conformPasswordTextField: UITextField!

    let signUpViewModel = SignUpViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.isSecureTextEntry = true
    }

    @IBAction func signUpBtn(_ sender: Any) {
        let firstName = firstNameTextField.text
        let secondName = secondNameTextField.text
        let email = emailTextField.text
        let mobile = mobileTextField.text
        let password = passwordTextField.text
        let conformPassword = conformPasswordTextField.text

        let validation = signUpViewModel.validateFields(firstName: firstName, secondName: secondName, email: email, mobile: mobile, password: password, conformPassword: conformPassword)

        if !validation.0 {
            showError(validation.1 ?? "Validation Error")
            return
        }

        signUpViewModel.createUser(firstName: firstName!, secondName: secondName!, email: email!, mobile: mobile!, password: password!) { success, message in
            DispatchQueue.main.async {
                if success {
                    self.showSuccess(message ?? "Sign up successful! Please check your email for verification.")
                } else {
                    self.showError(message ?? "Sign up failed")
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

