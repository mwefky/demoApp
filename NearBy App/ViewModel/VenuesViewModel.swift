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
    var appState = AppState.SingleUpdate
    var navItemTitle = Dynamic("")
    var error = Dynamic("")
    
    func fetchVenues(lat: CLLocationDegrees,lon: CLLocationDegrees){

        APIManager.shared.getNearByPlaces(lat: lat, lon: lon, completed: {(Placesobj, error) in
            
            
            guard let places = Placesobj?.response else {self.error.value = error.debugDescription
                return
            }
            self.venue.value = places.venues ?? []
        })
    }
    
    
    mutating func alternateAppState() {
        
        if appState == .SingleUpdate {
            navItemTitle.value = "Single Update"
            appState = .realTime
        }else {
            navItemTitle.value = "RealTime"
            appState = .SingleUpdate
        }
    }
}



//MARK:- states enum
enum AppState {
    case realTime
    case SingleUpdate
}
