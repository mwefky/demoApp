//
//  PlacesViewModel.swift
//  NearBy App
//
//  Created by mina wefky on 7/10/20.
//  Copyright © 2020 mina wefky. All rights reserved.
//

import Foundation
import CoreLocation
struct VenuesViewModel {
    
    
    let venue = Dynamic([Venue]())
    var locManager = CLLocationManager()
    var navItemTitle = Dynamic("")
    var error = Dynamic("")
    
    func fetchVenues(lat: CLLocationDegrees,lon: CLLocationDegrees){

        APIManager.shared.getNearByPlaces(lat: lat, lon: lon, completed: {(NearBYOBJ, error) in
            
            
            guard let places = NearBYOBJ?.response else {self.error.value = error.debugDescription
                return
            }
            
            let tempObj = places.groups.first?.items
            var tempArr = [Venue]()
            for i in tempObj ?? [] {
                tempArr.append(i.venue)
            }
            self.venue.value = tempArr
        })
    }
    
    
    mutating func alternateAppState() {
        
        if UserDefaults.standard.bool(forKey: ISSINGLEUPDATE) {
            navItemTitle.value = "Single Update"
            UserDefaults.standard.set(false, forKey: ISSINGLEUPDATE)
            UserDefaults.standard.synchronize()
        }else {
            navItemTitle.value = "RealTime"
            UserDefaults.standard.set(true, forKey: ISSINGLEUPDATE)
            UserDefaults.standard.synchronize()
        }
    }
}

