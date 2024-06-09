//
//  ApiServices.swift
//  ShopifyApp
//
//  Created by Aya Mostafa on 02/06/2024.
//

import Foundation
import Alamofire

class ApiServices {
    static let shared = ApiServices()
    func fetchData<T: Codable>(urlString: String, completion: @escaping (Result<T, Error>) -> Void) {
        AF.request(urlString).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
