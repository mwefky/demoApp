//
//  ViewController.swift
//  NearBy App
//
//  Created by mina wefky on 7/8/20.
//  Copyright © 2020 mina wefky. All rights reserved.
//

import UIKit
import CoreLocation
class ViewController: UIViewController {
    
    
    //MARK:- outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- variables
    var tableState = TableState.loading
    var locManager = CLLocationManager()
    
    var venuesViewModel = VenuesViewModel()
    var venues = [Venue]()
    
    var intialLoc: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locManager.requestAlwaysAuthorization()
       
        
        bindViewModel()
        setUpNavBar()
        
        //MARK: delegates
        tableView.delegate = self
        tableView.dataSource = self
        locManager.delegate = self
        locManager.requestLocation()
        
        getLocation()
        tableView.register(StateTableViewCell.self, forCellReuseIdentifier: "StateTableViewCell")
        tableView.register(UINib(nibName: "StateTableViewCell", bundle: nil), forCellReuseIdentifier: "StateTableViewCell")
        
        tableView.register(NearByTableViewCell.self, forCellReuseIdentifier: "NearByTableViewCell")
        tableView.register(UINib(nibName: "NearByTableViewCell", bundle: nil), forCellReuseIdentifier: "NearByTableViewCell")
        
        
    }
    
    //MARK:- UI
    func setUpNavBar() {
        
        self.title = "Near By"
        var navBtTitile = ""
        !UserDefaults.standard.bool(forKey: ISSINGLEUPDATE) ? (navBtTitile = "Single Update") : (navBtTitile = "RealTime")
        navigationItem.setRightBarButton(UIBarButtonItem(title: navBtTitile, style: .plain, target: self, action: #selector(changeAppMode)), animated: true)
    }
    
    @objc func changeAppMode(){
        
        venuesViewModel.alternateAppState()
    }
    
    
    //MARK:- binding
    func bindViewModel() {
        
        venuesViewModel.venue.bind { (vens) in
            DispatchQueue.main.async {
                [weak self] in
                if vens.count == 0 {
                    self?.tableState = .empty
                    self?.tableView.reloadData()
                    return
                }
                self?.venues = vens
                self?.tableState = .populated
                self?.tableView.reloadData()
            }
        }
        
        venuesViewModel.error.bind { (error) in
            DispatchQueue.main.async {
                [weak self] in
                self?.tableState = .error
                self?.tableView.reloadData()
            }
        }
        
        
        venuesViewModel.navItemTitle.bind { (title) in
            DispatchQueue.main.async {
                [weak self] in
                self?.navigationItem.setRightBarButton(UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(self?.changeAppMode)), animated: true)
            }
        }
    }
    
    //MARK:- Location Update
    
    func getLocation() {
        
        guard let lat = locManager.location?.coordinate.latitude, let lon = locManager.location?.coordinate.longitude else {
            locManager.requestLocation()
            return
            }
        tableState = .loading
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() ==  .authorizedAlways {
            
            intialLoc = locManager.location
            venuesViewModel.fetchVenues(lat: lat, lon: lon)
        }
    }
    
    
    
}



//MARK:- TableView Delegate/DataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableState {
        case .loading, .error, .empty:
            return 1
        case .populated:
            return venues.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableState {
        case .loading:
            let cell = tableView.dequeueReusableCell(withIdentifier: "StateTableViewCell") as! StateTableViewCell
            cell.state = .loading
            return cell
        case .populated:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NearByTableViewCell") as! NearByTableViewCell
            cell.venue = venues[indexPath.row]
            return cell
        case .error:
            let cell = tableView.dequeueReusableCell(withIdentifier: "StateTableViewCell") as! StateTableViewCell
            cell.state = .error
            return cell
        case .empty:
            let cell = tableView.dequeueReusableCell(withIdentifier: "StateTableViewCell") as! StateTableViewCell
            cell.state = .empty
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableState {
        case .loading, .error, .empty:
            return tableView.frame.height
        case .populated:
            return 102
        }
    }
    
}

//MARK:- LocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         print("error:: \(error.localizedDescription)")
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locManager.requestLocation()
            getLocation()
        }else {
            tableState = .error
            tableView.reloadData()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if locations.last != nil {
            guard let loc  = intialLoc else { getLocation()
                return }
            if ((loc.distance(from: locations.last!)) / 1000) > 500 &&
                !UserDefaults.standard.bool(forKey: ISSINGLEUPDATE) {
                    self.view.backgroundColor = .black
                    getLocation()
                }
        }
    }
    

}
    



//MARK:- states enum
enum TableState {
    case loading
    case empty
    case populated
    case error
}




let ISSINGLEUPDATE = "ISSINGLEUPDATE"
