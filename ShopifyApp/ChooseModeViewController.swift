//
//  ChooseModeViewController.swift
//  ShopifyApp
//
//  Created by Salma on 21/06/2024.
//

import UIKit
import Reachability

class ChooseModeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func navigateToGuestMode(_ sender: Any) {
        
        
        let reachability = try! Reachability()
        
        switch reachability.connection {
            
        case .wifi , .cellular :
            
            UserDefaultsManager.shared.saveAsGuest()
            
            let part1Storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let homeScreen = part1Storyboard.instantiateViewController(withIdentifier: "naviagtion")
            
            present(homeScreen, animated: true)
            
        case .unavailable :
            let alert = UIAlertController(title: "network" ,  message: "Check your network first !", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
    
    @IBAction func navigateToRegister(_ sender: Any) {
        
        let reachability = try! Reachability()
        
        switch reachability.connection {
            
        case .wifi , .cellular :
            
        
        let part3Storyboard = UIStoryboard(name: "Part3", bundle: nil)
        
        let signUpScreen = part3Storyboard.instantiateViewController(withIdentifier: "signUp_screen")
    
        present(signUpScreen, animated: true)
            
        case .unavailable :
            let alert = UIAlertController(title: nil ,  message: "Check your network first !", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
        
        
        
    }
    @IBAction func navigateToLogin(_ sender: Any) {
        
        let reachability = try! Reachability()
        
        switch reachability.connection {
            
        case .wifi , .cellular :
        
        let part3Storyboard = UIStoryboard(name: "Part3", bundle: nil)
        
        let loginScreen = part3Storyboard.instantiateViewController(withIdentifier: "loginScreen")
    
        present(loginScreen, animated: true)
            
        case .unavailable :
            let alert = UIAlertController(title: nil ,  message: "Check your network first !", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
        
        
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
