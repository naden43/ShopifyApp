//
//  SignUpViewModel.swift
//  ShopifyApp
//
//  Created by Salma on 03/06/2024.
//



import Foundation
import Firebase
import FirebaseAuth



class SignUpViewModel {
    var currentCustomer: PostedCustomerResponse?
    
    func validateFields(firstName: String?, secondName: String?, email: String?, mobile: String?, password: String?, conformPassword: String?) -> (Bool, String?) {
       let mobileRegex = #"^\d{11}$"#
        
        guard let firstName = firstName, !firstName.isEmpty,
              let secondName = secondName, !secondName.isEmpty,
              let email = email, !email.isEmpty,
              let mobile = mobile, !mobile.isEmpty,
              let password = password, !password.isEmpty,
              let conformPassword = conformPassword, !conformPassword.isEmpty else {
            return (false, "All fields are required.")
        }
        
        guard password == conformPassword else {
            return (false, "Passwords do not match.")
        }
        
     
        let mobilePredicate = NSPredicate(format: "SELF MATCHES %@", mobileRegex)
        if !mobilePredicate.evaluate(with: mobile) {
            return (false, "Invalid mobile number format.")
        }
        if !isValidPassword(password) {
              return (false, "Password must be at least 8 characters long, contain a number, an uppercase letter, a lowercase letter, and a special character.")
          }
        return (true, nil)
    }
    private func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[#$^+=!*()@%&]).{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }

    
    func createUser(firstName: String, secondName: String, email: String, mobile: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(false, error.localizedDescription)
            } else if let user = authResult?.user {
                // Send email verification
                user.sendEmailVerification { error in
                    if let error = error {
                        completion(false, error.localizedDescription)
                    } else {
                        self.handleEmailVerificationCompletion(firstName: firstName, secondName: secondName, email: email, mobile: mobile, password: password, completion: completion)
                    }
                }
            }
        }
    }
    
    func handleEmailVerificationCompletion(firstName: String, secondName: String, email: String, mobile: String, password: String, completion: @escaping (Bool, String?) -> Void) {
       
        let customerData = CustomerData(first_name: firstName, last_name: secondName, email: email, phone: mobile, tags: password)
        let customer = PostedCustomerRequest(customer: customerData)
        NetworkHandler.instance.postData(customer, to: "admin/api/2024-04/customers.json", responseType: PostedCustomerResponse.self) { success, message, responseData in
            if success, let customerResponse = responseData {
                self.currentCustomer = customerResponse
                self.createDraftOrder()
                completion(true, "Customer created successfully!")
            } else {
                completion(false, message ?? "Failed to create customer")
            }
        }
    }
    
    func createDraftOrder() {
        let firstLineItems = LineItem(title: "bag", quantity: 1, price: "100")
        let firstDraftOrder = DraftOrder(lineItems: [firstLineItems], customer: currentCustomer?.customer)
        
        NetworkHandler.instance.postData(DraftOrders(draftOrder: firstDraftOrder), to: "admin/api/2024-04/draft_orders.json", responseType: DraftOrders.self) { success, message, responseData in
            if success, let firstDraftOrderResponse = responseData {
                print("Draft order created successfully!")
                
                let secondDraftOrder = DraftOrder(lineItems: [firstLineItems], customer: self.currentCustomer?.customer)
                
                NetworkHandler.instance.postData(DraftOrders(draftOrder: secondDraftOrder), to: "admin/api/2024-04/draft_orders.json", responseType: DraftOrders.self) { success, message, responseData in
                    if success, let secondDraftOrderResponse = responseData {
                        print("Second draft order created successfully!")
                        
                        let draftOrdersIds = "\(firstDraftOrderResponse.draftOrder.id ?? 0),\(secondDraftOrderResponse.draftOrder.id ?? 0)"
                        self.currentCustomer?.customer.note = draftOrdersIds
                        
                        NetworkHandler.instance.putData(self.currentCustomer, to: "admin/api/2024-04/customers/\(self.currentCustomer?.customer.id ?? 0).json", responseType: PostedCustomerResponse.self) { success, message, responseData in
                            if success, let customerResponse = responseData {
                                print("Customer updated successfully!")
                            } else {
                                print("Failed to update customer: \(message ?? "No error message")")
                            }
                        }
                        
                    } else {
                        print("Failed to create second draft order: \(message ?? "No error message")")
                    }
                }
                
            } else {
                print("Failed to create first draft order: \(message ?? "No error message")")
            }
        }
    }
    
}
