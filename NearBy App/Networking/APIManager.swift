//
//  APIManager.swift
//  NearBy App
//
//  Created by mina wefky on 7/9/20.
//  Copyright © 2020 mina wefky. All rights reserved.
//

import Foundation
import CoreLocation


class APIManager {

    static let shared = APIManager()
    let client_id = "3RSELVTMAIARDHBTU1LMQ10RUM4ORQD2TUTCW3HPTA5L5YCH"
    let client_secret = "GUSNGZJNF2BZFDVKOBB1AO1QQFIKNJDW4AM0SUFR0L0LJWM1"
    let baseURL = "https://api.foursquare.com/v2/venues/explore"
    let basePICURL = "https://api.foursquare.com/v2/venues/VENUE_ID/photos"
    
    func getNearByPlaces(lat: CLLocationDegrees,lon: CLLocationDegrees,completed: @escaping (NearBy?, Error?)->()){
        
        let prams = ["ll": "\(lat),\(lon)" ,"client_id": client_id, "client_secret": client_secret,"v":"20200707", "radius": "1000"]
        
        Network.shared.fetchCodableObject(method: .get, url: baseURL, parameters: prams) { (result, error) in
            
            if error != nil {
                completed(nil,error)
            }
            
            do {
                guard let json = result else {return}
                let places = try JSONDecoder().decode(NearBy.self, from: json)
                completed(places, nil)
            } catch let error {
                print("Error creating object from JSON: \(error.localizedDescription)")
                completed(nil,error)
            }
        }
    }
    
    
    func getVenuPic(id: String,completed: @escaping (PhotoBaseModel?, Error?)->()){
        
        let prams = ["client_id": client_id, "client_secret": client_secret,"v":"20200707"]
        var url = basePICURL.replacingOccurrences(of: "VENUE_ID", with: id)
        Network.shared.fetchCodableObject(method: .get, url: url, parameters: prams) { (result, error) in
        
        if error != nil {
            completed(nil,error)
        }
        
        do {
            guard let json = result else {return}
            let photosBase = try JSONDecoder().decode(PhotoBaseModel.self, from: json)
            completed(photosBase, nil)
        } catch let error {
            print("Error creating object from JSON: \(error.localizedDescription)")
            completed(nil,error)
        }
        }
        
        
    }
    
}






