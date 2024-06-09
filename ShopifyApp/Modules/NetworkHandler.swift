//
//  NetworkHandler.swift
//  ShopifyApp
//
//  Created by Salma on 09/06/2024.
//

import Foundation
import Alamofire

class NetworkHandler {
    
    static let shared = NetworkHandler()
    private let baseUrl = "https://mad44-sv-team4.myshopify.com/"
    private let apiKey = "76854ee270534b0f6fe7e7283f53b057"
    private let password = "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"
    
    private var authHeader: String {
        let loginString = String(format: "%@:%@", apiKey, password)
        let loginData = loginString.data(using: .utf8)!
        return "Basic \(loginData.base64EncodedString())"
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
    
    
    func postData<T: Encodable, U: Decodable>(_ data: T, to endpoint: String, responseType: U.Type, completion: @escaping (Bool, String? , U?) -> Void) {
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            completion(false, "Invalid URL",nil)
            return
        }
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
                    completion(false, "Request error: \(error.localizedDescription)" , nil)
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
    
    
    
    
}

