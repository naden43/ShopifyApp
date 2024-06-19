//
//  LoginViewController.swift
//  ShopifyApp
//
//  Created by Salma on 09/06/2024.
//
/*import UIKit

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



*/


//
//  LoginViewController.swift
//  ShopifyApp
//
//  Created by Salma on 09/06/2024.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        passwordTextField.isSecureTextEntry = true
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
                self.checkEmailVerificationAndProceed()
            } else {
                self.showError(message)
            }
        }
    }
    
    private func checkEmailVerificationAndProceed() {
        guard let user = Auth.auth().currentUser else {
            showError("User not found.")
            return
        }
        
        user.reload { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                print("Error reloading user: \(error.localizedDescription)")
                self.showError("Failed to reload user data.")
                return
            }
            
            if user.isEmailVerified {
                self.showSuccess("Login successful!")
                self.viewModel.printSavedCustomerData()
                self.navigateToHome()
            } else {
                self.showError("Please verify your email to login.")
                
            }
        }
    }
    
    private func navigateToHome() {
        print("Navigating to home...")
        
        let storyboard = UIStoryboard(name: "Part1", bundle: nil)
        guard let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeScViewController else {
            print("Failed to instantiate HomeViewController from storyboard")
            return
        }
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(homeVC, animated: true)
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


