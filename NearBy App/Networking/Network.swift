//
//  Network.swift
//  Infra
//
//  Created by Peter Livesey on 3/23/19.
//  Copyright © 2019 Aspen Designs. All rights reserved.
//

import Foundation
import Alamofire



class Network {
    static let shared = Network()
    
    
    func fetchCodableObject(method: HTTPMethod, url: String, parameters: [String: Any]?,completed: @escaping (Data?, Error?)->() ){
        
        
        AF.request(URL(string: url)!, method: method, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON{response in
            
            print("URL is: \(response.request!.url!.absoluteString)")
            switch response.result {
            case .success(let value):
                print("Request success: \(value)")
                print("==============================")
                
                if (200 ... 299).contains(response.response!.statusCode) {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        completed(jsonData, nil)
                    } catch let error {
                        completed(nil, error)
                    }
                    
                } else {
                    let error = NSError(domain: "", code: response.response!.statusCode, userInfo: nil)
                    completed(nil,error)
                }
                
            case .failure(let error):
                print("Request failed: \(error.localizedDescription)")
                print("==============================")
                completed(nil, error)
            }
            
        }
    }
}
