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

    
    
    
    func putData<T: Encodable, U: Decodable>(_ data: T, to endpoint: String, responseType: U.Type, completion: @escaping (Bool, String? , U?) -> Void) {
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            completion(false, "Invalid URL" , nil)
            
            return
        }
        let headers: HTTPHeaders = [
            "Authorization": authHeader,
            "Content-Type": "application/json"
        ]
        AF.request(url, method: .put, parameters: data, encoder: JSONParameterEncoder.default, headers: headers)
            .validate()
            .responseDecodable(of: U.self) { response in
                switch response.result {
                case .success  (let value):
                    completion(true, "succeeded", value )
                case .failure(let error):
                    completion(false, "Request error: \(error.localizedDescription)", nil)
                }
            }
        
        
    }
    

    func postData<T: Encodable, U: Decodable>(_ data: T, to endpoint: String, responseType: U.Type, completion: @escaping (Bool, String? , U?) -> Void) {
             guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
                 completion(false, "Invalid URL",nil)
                 return
             }
        
            print("the url is = \(url)")
             let headers: HTTPHeaders = [
                 "Authorization": authHeader,
                 "Content-Type": "application/json"
             ]
        
        do {
            let jsonData = try JSONEncoder().encode(data)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("Request JSON: \(jsonString)")
            }
        } catch {
            completion(false, "Failed to encode JSON: \(error.localizedDescription)", nil)
            return
        }
        
             AF.request(url, method: .post, parameters: data, encoder: JSONParameterEncoder.default, headers: headers)
            .validate()
                 .responseDecodable(of: U.self) { response in
                     switch response.result {
                     case .success(let value):
                         completion(true, "succeeded",value)
                     case .failure(let error):
                         completion(false, "\(response.response?.statusCode ?? 0)" , nil)
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
    
    
 /*   func getAddresses(complitionHandler : @escaping ([ReturnAddress]) -> Void){
        
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
        
    }*/
    
}
