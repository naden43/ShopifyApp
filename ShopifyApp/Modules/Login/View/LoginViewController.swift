//
//  LoginViewController.swift
//  ShopifyApp
//
//  Created by Salma on 09/06/2024.
//
import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    private let viewModel = LoginViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func loginButton(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showError("Please enter both email and password.")
            return
        }

        viewModel.validateAndLogin(email: email, password: password) { [weak self] success, message in
            guard let self = self else { return }
            if success {
                self.showSuccess(message)
                self.viewModel.printSavedCustomerData()  
            } else {
                self.showError(message)
            }
        }
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func showSuccess(_ message: String) {
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}



