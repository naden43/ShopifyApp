//
//  LoginViewModel.swift
//  ShopifyApp
//
//  Created by Salma on 09/06/2024.
//

class LoginViewModel {
    
    func validateAndLogin(email: String, password: String, completion: @escaping (Bool, String) -> Void) {
        
        guard !email.isEmpty, !password.isEmpty else {
            completion(false, "Please enter both email and password.")
            return
        }

        getAllCustomers { customers, message in
            guard let customers = customers else {
                completion(false, "Failed to retrieve customers: \(message ?? "Unknown error")")
                return
            }

            if let customer = customers.first(where: { $0.email == email && $0.tags == password }) {
                self.saveCustomerToUserDefaults(customer: customer)
                completion(true, "Login successful")
                self.printSavedCustomerData()
            } else {
                completion(false, "Invalid email or password.")
            }
        }
    }
    
    private func getAllCustomers(completionHandler: @escaping ([Customer]?, String?) -> Void) {
        NetworkHandler.instance.getData(endPoint: "admin/api/2024-04/customers.json") { (response: AllCustomersResponse?, message) in
            if let customers = response?.customers {
                completionHandler(customers, "Success")
            } else {
                completionHandler(nil, message)
            }
        }
    }

    private func saveCustomerToUserDefaults(customer: Customer) {
        UserDefaultsManager.shared.saveCustomer(id: customer.id ?? 0, note: customer.note)
    }

    func printSavedCustomerData() {
        let customerData = UserDefaultsManager.shared.getCustomer()
        print("Customer ID: \(customerData.id ?? 0)")
        print("Favorite Products Draft Order ID: \(customerData.favProductsDraftOrderId ?? "nil")")
        print("Shopping Cart Draft Order ID: \(customerData.shoppingCartDraftOrderId ?? "nil")")
    }
}



