//
//  ChooseModeViewController.swift
//  ShopifyApp
//
//  Created by Salma on 21/06/2024.
//

import UIKit

class ChooseModeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func navigateToGuestMode(_ sender: Any) {
        
        UserDefaultsManager.shared.saveAsGuest()
        
        let part1Storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let homeScreen = part1Storyboard.instantiateViewController(withIdentifier: "naviagtion")
    
        present(homeScreen, animated: true)
        
    }
    
    @IBAction func navigateToRegister(_ sender: Any) {
        
        let part3Storyboard = UIStoryboard(name: "Part3", bundle: nil)
        
        let signUpScreen = part3Storyboard.instantiateViewController(withIdentifier: "signUp_screen")
    
        present(signUpScreen, animated: true)
        
        
        
    }
    @IBAction func navigateToLogin(_ sender: Any) {
        
        let part3Storyboard = UIStoryboard(name: "Part3", bundle: nil)
        
        let loginScreen = part3Storyboard.instantiateViewController(withIdentifier: "loginScreen")
    
        present(loginScreen, animated: true)
        
        
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
