//
//  LoginViewController.swift
//  ShopifyApp
//
//  Created by Salma on 09/06/2024.
//
//
//  LoginViewController.swift
//  ShopifyApp
//
//  Created by Salma on 09/06/2024.
//

import UIKit
import FirebaseAuth
import Reachability

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private let viewModel = LoginViewModel()
    let activityIndicator = UIActivityIndicatorView(style: .large)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordTextField.isSecureTextEntry = true
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        
        let reachability = try! Reachability()
        
        switch reachability.connection {
            
        case .wifi , .cellular :
            guard let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty else {
                showError("Please enter both email and password.")
                return
            }
            
            self.activityIndicator.center = self.view.center
            self.view.addSubview(self.activityIndicator)
            self.activityIndicator.startAnimating()
            
            Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
                if let error = error {
                    self.activityIndicator.stopAnimating()
                    
                    let alert = UIAlertController(title: "error", message: error.localizedDescription, preferredStyle: .actionSheet)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    
                    self.present(alert, animated: true)
                    
                }
                else {
                    self.viewModel.validateAndLogin(email: email, password: password) { [weak self] success, message,customer  in
                        guard let self = self else { return }
                        guard let customer = customer else {return}
                        if success {
                            self.checkEmailVerificationAndProceed(customer: customer)
                        } else {
                            self.showError(message)
                        }
                    }
                }
            }
            
        case .unavailable :
            let alert = UIAlertController(title: nil ,  message: "Check your network first !", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
            
        }
    }
    
    @IBAction func back(_ sender: Any) {
        
        dismiss(animated: true)
        
    }
    private func checkEmailVerificationAndProceed(customer:Customer) {
        
        
        guard let user = Auth.auth().currentUser else {
            activityIndicator.stopAnimating()
            showError("User not found.")
            return
        }
        user.reload { [weak self] error in
            
            self?.activityIndicator.stopAnimating()

            guard let self = self else { return }
            if let error = error {
                print("Error reloading user: \(error.localizedDescription)")
                self.showError("Failed to reload user data.")
                return
            }
            
            if user.isEmailVerified{
                //self.showSuccess("Login successful!")
                self.viewModel.saveCustomerToUserDefaults(customer: customer)
                self.viewModel.printSavedCustomerData()
                self.navigateToHome()
            } else {
                self.showError("Please verify your email to login.")
                
            }
        }
    }
    
    private func navigateToHome() {
        print("Navigating to home...")
        
        let part1Storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let homeScreen = part1Storyboard.instantiateViewController(withIdentifier: "naviagtion")
    
        present(homeScreen, animated: true)

        
        
       
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




//
//  LoginViewController.swift
//  ShopifyApp
//
//  Created by Salma on 09/06/2024.
//
//
//import UIKit
//import FirebaseAuth
//
//class LoginViewController: UIViewController {
//    @IBOutlet weak var emailTextField: UITextField!
//    @IBOutlet weak var passwordTextField: UITextField!
//
//    private let viewModel = LoginViewModel()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//
//        passwordTextField.isSecureTextEntry = true
//    }
//
//    @IBAction func loginButton(_ sender: UIButton) {
//        guard let email = emailTextField.text, !email.isEmpty,
//              let password = passwordTextField.text, !password.isEmpty else {
//            showError("Please enter both email and password.")
//            return
//        }
//
//        viewModel.validateAndLogin(email: email, password: password) { [weak self] success, message,customer  in
//            guard let self = self else { return }
//            guard let customer = customer else {return}
//            if success {
//                self.checkEmailVerificationAndProceed(customer: customer)
//            } else {
//                self.showError(message)
//            }
//        }
//    }
//
//    @IBAction func back(_ sender: Any) {
//
//        dismiss(animated: true)
//
//    }
//    private func checkEmailVerificationAndProceed(customer:Customer) {
//        guard let user = Auth.auth().currentUser else {
//            showError("User not found.")
//            return
//        }
//        user.reload { [weak self] error in
//            guard let self = self else { return }
//            if let error = error {
//                print("Error reloading user: \(error.localizedDescription)")
//                self.showError("Failed to reload user data.")
//                return
//            }
//
//            if user.isEmailVerified{
//                //self.showSuccess("Login successful!")
//                self.viewModel.saveCustomerToUserDefaults(customer: customer)
//                self.viewModel.printSavedCustomerData()
//                self.navigateToHome()
//            } else {
//                self.showError("Please verify your email to login.")
//
//            }
//        }
//    }
//
//    private func navigateToHome() {
//        print("Navigating to home...")
//
//        let part1Storyboard = UIStoryboard(name: "Main", bundle: nil)
//
//        let homeScreen = part1Storyboard.instantiateViewController(withIdentifier: "naviagtion")
//
//        present(homeScreen, animated: true)
//
//
//
//
//    }
//
//    private func showError(_ message: String) {
//        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default))
//        present(alert, animated: true)
//    }
//
//    private func showSuccess(_ message: String) {
//        let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default))
//        present(alert, animated: true)
//    }
//}
//
//
