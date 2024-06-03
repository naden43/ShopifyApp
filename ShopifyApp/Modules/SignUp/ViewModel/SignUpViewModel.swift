//
//  SignUpViewModel.swift
//  ShopifyApp
//
//  Created by Salma on 03/06/2024.
//

import Foundation
import Firebase
import FirebaseAuth

class SignUpViewModel{
    
    func createUser(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
              
                completion(false, error.localizedDescription)
            } else {
            
                completion(true, nil)
            }
        }
    }
    
}



