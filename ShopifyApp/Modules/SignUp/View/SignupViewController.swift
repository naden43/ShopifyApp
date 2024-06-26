//
//  SignUpViewController.swift
//  ShopifyApp
//
//  Created by Salma on 03/06/2024.
//

import UIKit
import FirebaseAuth
import Reachability
class SignUpViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var secondNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var conformPasswordTextField: UITextField!
    
    let signUpViewModel = SignUpViewModel()
    
    
    let activityIndicator = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        passwordTextField.isSecureTextEntry = true
        conformPasswordTextField.isSecureTextEntry = true
        
        passwordTextField.placeholder = "Password (min 8 characters, 1 number, 1 uppercase, 1 special character)"
        conformPasswordTextField.placeholder = "Confirm Password"
    }
    
    @IBAction func signUpBtn(_ sender: Any) {
        
        let reachability = try! Reachability()
        
        switch reachability.connection {
            
        case .wifi , .cellular :
            
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
        
        
            self.activityIndicator.center = self.view.center
            self.view.addSubview(self.activityIndicator)
            self.activityIndicator.startAnimating()
            
        signUpViewModel.createUser(firstName: firstName!, secondName: secondName!, email: email!, mobile: mobile!, password: password!) { success, message in
            DispatchQueue.main.async {
                if success {
                    self.activityIndicator.stopAnimating()

                    //self.showSuccess(message ?? "Sign up successful! Please check your email for verification.")
                    self.naviagteToLoginScreen()
                    
                } else {
                    self.activityIndicator.stopAnimating()

                    self.showError(message ?? "Sign up failed")
                }
            }
        }
        case .unavailable :
            let alert = UIAlertController(title: nil ,  message: "Check your network first !", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
            
        }
    }
    
    func naviagteToLoginScreen() {
        let part3Storyboard = UIStoryboard(name: "Part3", bundle: nil)
        
        let loginScreen = part3Storyboard.instantiateViewController(withIdentifier: "loginScreen")
    
        present(loginScreen, animated: true)
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
    
    
    func showPasswordValidationError() {
        let alert = UIAlertController(title: "Password Validation Error", message: "Password must be at least 8 characters long, contain a number, an uppercase letter, a lowercase letter, and a special character.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
        
    }
        @IBAction func back(_ sender: Any) {
            dismiss(animated: true)
            
            
        }
    }
