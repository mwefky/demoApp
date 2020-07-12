//
//  PlacesViewModel.swift
//  NearBy App
//
//  Created by mina wefky on 7/10/20.
//  Copyright © 2020 mina wefky. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift

struct VenuesViewModel {
    
    var venueVar = Variable([Venue]())
    var navItemTitleVar = Variable("")
    var errorVar = Variable("")
    
    var venue: Observable<([Venue])>{
        
        return venueVar.asObservable()
    }
    var navItemTitle: Observable<String>{
        return navItemTitleVar.asObservable()
    }
    var error: Observable<String>{
        return errorVar.asObservable()
    }
    
    var locManager = CLLocationManager()
    
    func fetchVenues(lat: CLLocationDegrees,lon: CLLocationDegrees){

        APIManager.shared.getNearByPlaces(lat: lat, lon: lon, completed: {(NearBYOBJ, error) in
            
            
            guard let places = NearBYOBJ?.response else {self.errorVar.value = error.debugDescription
                return
            }
            
            let tempObj = places.groups.first?.items
            var tempArr = [Venue]()
            for i in tempObj ?? [] {
                tempArr.append(i.venue)
            }
            
            self.venueVar.value = tempArr
        })
    }
    
    
    mutating func alternateAppState() {
        
        if UserDefaults.standard.bool(forKey: ISSINGLEUPDATE) {
            navItemTitleVar.value = "Single Update"
            UserDefaults.standard.set(false, forKey: ISSINGLEUPDATE)
            UserDefaults.standard.synchronize()
        }else {
            navItemTitleVar.value = "RealTime"
            UserDefaults.standard.set(true, forKey: ISSINGLEUPDATE)
            UserDefaults.standard.synchronize()
        }
    }
}

