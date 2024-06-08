//
//  NetworkHandler.swift
//  ShopifyApp
//
//  Created by Naden on 03/06/2024.
//

import Foundation
import Alamofire

class NetworkHandler {
    
    
    static var instance = NetworkHandler()
    
    private let baseUrl = "https://mad44-sv-team4.myshopify.com/"
    private let apiKey = "76854ee270534b0f6fe7e7283f53b057"
    private let password = "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"
    
    
    private var authHeader: String {
          let loginString = String(format: "%@:%@", apiKey, password)
          let loginData = loginString.data(using: .utf8)!
          return "Basic \(loginData.base64EncodedString())"
      }
    
    private init(){}
    
    
    func convertDictionaryToJSON(_ dictionary: [String: Any]) -> String? {

       guard let jsonData = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted) else {
          print("Something is wrong while converting dictionary to JSON data.")
          return nil
       }

       guard let jsonString = String(data: jsonData, encoding: .utf8) else {
          print("Something is wrong while converting JSON data to JSON string.")
          return nil
       }

       return jsonString
    }
    
    func postAddress(_ address:ReturnAddress, completion: @escaping (Bool, String?) -> Void) {
                guard let url = URL(string: "https://mad44-sv-team4.myshopify.com/admin/api/2024-04/customers/7864239587494/addresses.json") else {
                    completion(false, "Invalid URL")
                    return
                }
                
                var request = URLRequest(url: url)
                let apiKey = "76854ee270534b0f6fe7e7283f53b057"
                let password = "shpat_d3fad62e284068d7cfef1f8b28b0d7a"
                request.httpMethod = "POST"
                let loginString = String(format: "%@:%@", apiKey, password)
                let loginData = loginString.data(using: String.Encoding.utf8)!
                let base64LoginString = loginData.base64EncodedString()
                
                request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let customerDictionary: [String: Any] = [
                    "address": [
                        "first_name": address.first_name ?? ""
                    ]
                ]
                print(customerDictionary)
            
                do {
                   // request.httpBody = try JSONEncoder().encode(AddressObject(address: address))
                    request.httpBody = try JSONSerialization.data(withJSONObject: customerDictionary, options: [])
                } catch {
                    completion(false, "Failed to serialize JSON")
                    return
                }
                
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error = error {
                        completion(false, "Request error: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let data = data else {
                        completion(false, "No data received")
                        return
                    }
                    
                    do {
                        
                        print(response)
                        let temp = try JSONDecoder().decode(CustomAddress.self, from: data)
                        
                        print(temp)
                        //if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                           // print("Response: \(jsonResponse)")
                            completion(true , "")
                            /*if let customer = jsonResponse["address"] as? [String: Any] {
                                completion(true, "Customer created with ID: \(customer["id"] ?? "unknown")")
                            } else {
                                completion(false, "Failed")
                            }*/
                        }
                    catch let error {
                        print(error)
                        completion(false, "Failed to parse JSON")
                    }
                }
                
                task.resume()
            }
    
    
   
    
    func postAddress2(_ address: ReturnAddress, completion: @escaping (Bool, String?) -> Void) {
           let url = "https://mad44-sv-team4.myshopify.com/admin/api/2024-04/customers/7864239587494/addresses.json"
           
           let headers: HTTPHeaders = ["Authorization": "Basic \(Data("\(apiKey):\(password)".utf8).base64EncodedString())"]


           AF.request(url, method: .post, parameters: AddressObject(address: address), encoder: JSONParameterEncoder.default, headers: headers)
            .response{ response in
                   switch response.result {
                   case .success:
                       print(response.data)
                       completion(true, nil)
                   case .failure(let error):
                       completion(false, "Request error: \(error)")
                   }
               }
       }

    func deleteAddress(endPoint: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(baseUrl)\(endPoint)") else {
            completion(false)
            return
        }
        
        let headers: HTTPHeaders = ["Authorization": authHeader]
        AF.request(url, method: .delete, headers: headers)
            .validate(statusCode: 200..<300)
            .response { response in
                switch response.result {
                case .success:
                    completion(true)
                case .failure:
                    completion(false)
                }
            }
    }

    func postData<T: Encodable, U: Decodable>(_ data: T, to endpoint: String, responseType: U.Type, completion: @escaping (Bool, String? , U?) -> Void) {
             guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
                 completion(false, "Invalid URL",nil)
                 return
             }
        
            print(url)
             let headers: HTTPHeaders = [
                 "Authorization": authHeader,
                 "Content-Type": "application/json"
             ]
        
             AF.request(url, method: .post, parameters: data, encoder: JSONParameterEncoder.default, headers: headers)
                 .validate()
                 .responseDecodable(of: U.self) { response in
                     switch response.result {
                     case .success(let value):
                         completion(true, "succeeded",value)
                     case .failure(let error):
                         completion(false, "Request error: \(error.localizedDescription) \(response.response?.statusCode)" , nil)
                     }
            }
    }

    
    func getData<T:Codable>(endPoint : String , complitionHandler : @escaping (T? , String?)->Void ){
        
        guard  let url = URL(string: "\(baseUrl)\(endPoint)") else {
            complitionHandler(nil , "")
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": authHeader,
            "Content-Type": "application/json"
        ]
   
        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let value):
                    complitionHandler(value , "Success")
                case .failure(let error):
                    print(error)
                    complitionHandler(nil , "Faild")
                }
       }
        
        
        
    }
    
    
    func setDefaultAddress(endPoint:String , complition : @escaping (Bool)-> Void){
        
        guard  let url = URL(string: "\(baseUrl)\(endPoint)") else {
            complition(false)
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": authHeader,
            "Content-Type": "application/json"
        ]
   
        AF.request(url, method: .put, headers: headers)
            .validate()
            .response{ response in
                switch response.result {
                case .success(let value):
                    print(value)
                    complition(true)
                case .failure(let error):
                    print(error)
                    complition(false)
                }
       }
    }
    
    
    func getAddresses(complitionHandler : @escaping ([ReturnAddress]) -> Void){
        
        print("kkkkkkkk")
        guard  let url = URL(string: "https://76854ee270534b0f6fe7e7283f53b057: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@mad44-sv-team4.myshopify.com//admin/api/2024-04/customers/7866530955430/addresses.json") else {
            print("here")
            complitionHandler([])
            return
        }
        
        let requset = URLRequest(url: url)
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: requset) { data, response, error in
            guard let data = data else {
                complitionHandler([])
                return
            }
            
            do{
                
                let result = try JSONDecoder().decode(UserAddresses.self, from: data)
                complitionHandler(result.addresses)
                
            }
            catch {
                complitionHandler([])
            }
            
        }
        
        task.resume()
        
    }
    
}
