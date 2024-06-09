import Foundation
import Firebase
import FirebaseAuth

class SignUpViewModel {
    var currentCustomer : CustomerResponse?
    
    func validateFields(firstName: String?, secondName: String?, email: String?, mobile: String?, password: String?, conformPassword: String?) -> (Bool, String?) {
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
        
        return (true, nil)
    }
    
    func createUser(firstName: String, secondName: String, email: String, mobile: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(false, error.localizedDescription)
            } else {
                let customerData = CustomerData(first_name: firstName, last_name: secondName, email: email, phone: mobile, tags: password)
                let customer = PostedCustomer(customer: customerData)
                NetworkHandler.shared.postData(customer, to: "admin/api/2024-04/customers.json", responseType: CustomerResponse.self) { success, message, responseData in
                    if success, let customerResponse = responseData {
                        completion(true, "Customer created successfully!")
                        self.currentCustomer = customerResponse
                        self.createDraftOrder()
                      
                    } else {
                        completion(false, message ?? "Failed to create customer")
                    }
                }
            }
        }
    }
    
func createDraftOrder() {
        let firstLineItems = LineItem(title: "bag", quantity: 1, price: "100")
        let firstDraftOrder = DraftOrder(lineItems: [firstLineItems], customer: currentCustomer?.customer)
        
        NetworkHandler.shared.postData(DraftOrders(draftOrder: firstDraftOrder), to: "admin/api/2024-04/draft_orders.json", responseType: DraftOrders.self) { success, message, responseData in
            if success, let firstDraftOrderResponse = responseData {
                print("Draft order created successfully!")
                
                let secondDraftOrder = DraftOrder(lineItems: [firstLineItems], customer: self.currentCustomer?.customer)
                
                NetworkHandler.shared.postData(DraftOrders(draftOrder: secondDraftOrder), to: "admin/api/2024-04/draft_orders.json", responseType: DraftOrders.self) { success, message, responseData in
                    if success, let secondDraftOrderResponse = responseData {
                        print("Second draft order created successfully!")
                        
                        let draftOrdersIds = "\(firstDraftOrderResponse.draftOrder.id ?? 0),\(secondDraftOrderResponse.draftOrder.id ?? 0)"
                        self.currentCustomer?.customer?.note = draftOrdersIds
                        
                        NetworkHandler.shared.putData(self.currentCustomer, to: "admin/api/2024-04/customers/\(self.currentCustomer?.customer?.id ?? 0).json", responseType: CustomerResponse.self) { success, message, responseData in
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
