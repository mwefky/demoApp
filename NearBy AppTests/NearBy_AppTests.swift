//
//  NearBy_AppTests.swift
//  NearBy AppTests
//
//  Created by mina wefky on 7/8/20.
//  Copyright © 2020 mina wefky. All rights reserved.
//

import XCTest

@testable import NearBy_App

class NearBy_AppTests: XCTestCase {
    
    var mockNetwork: Network!
    var viewControllerUnderTest: ViewController!
    override func setUp() {
        mockNetwork = Network.shared
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.viewControllerUnderTest = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
    }
    
    override func tearDown() {
        mockNetwork = nil
        self.viewControllerUnderTest.loadView()
        self.viewControllerUnderTest.viewDidLoad()
        super.tearDown()
    }
    
    
    func testValidateNetWorkCallsForVenue(){
        
        let url = "https://api.foursquare.com/v2/venues/explore?client_id=3RSELVTMAIARDHBTU1LMQ10RUM4ORQD2TUTCW3HPTA5L5YCH&client_secret=GUSNGZJNF2BZFDVKOBB1AO1QQFIKNJDW4AM0SUFR0L0LJWM1&ll=29.994918823242188%2C31.205036542212873&radius=1000&v=20200707"
        
        let promise = expectation(description: "Status code: 200")
        mockNetwork.fetchCodableObject(method: .get, url: url, parameters: nil) { (response, error) in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    // 2
                    promise.fulfill()
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        wait(for: [promise], timeout: 5)
    }
    
    
    func testCallToiFoursquareCompletes(){
        let url = "https://api.foursquae.com/v2/venues/explore?client_id=3RSELVTMAIARDHBTU1LMQ10RUM4ORQD2TUTCW3HPTA5L5YCH&client_secret=GUSNGZJNF2BZFDVKOBB1AO1QQFIKNJDW4AM0SUFR0L0LJWM1&ll=29.994918823242188%2C31.205036542212873&radius=1000"
        let promise = expectation(description: "Completion handler invoked")
        var statusCode: Int?
        var responseError: Error?
        
        mockNetwork.fetchCodableObject(method: .get, url: url, parameters: nil) { (response, error) in
            statusCode = (response as? HTTPURLResponse)?.statusCode
            responseError = error
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
        
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }
    
    
    func testHasATableView() {
        XCTAssertNotNil(viewControllerUnderTest.tableView)
    }
    
    func testTableViewHasDelegate() {
        XCTAssertNotNil(viewControllerUnderTest.tableView.delegate)
    }
    
    func testTableViewConfromsToTableViewDelegateProtocol() {
           XCTAssertTrue(viewControllerUnderTest.conforms(to: UITableViewDelegate.self))
    }
    
    func testTableViewHasDataSource() {
        XCTAssertNotNil(viewControllerUnderTest.tableView.dataSource)
    }
    
    func testTableViewConformsToTableViewDataSourceProtocol() {
        XCTAssertTrue(viewControllerUnderTest.conforms(to: UITableViewDataSource.self))
        XCTAssertTrue(viewControllerUnderTest.responds(to: #selector(viewControllerUnderTest.tableView(_:numberOfRowsInSection:))))
        XCTAssertTrue(viewControllerUnderTest.responds(to: #selector(viewControllerUnderTest.tableView(_:cellForRowAt:))))
    }
    
    func testTableViewCellHasReuseIdentifier() {
           let cell = viewControllerUnderTest.tableView(viewControllerUnderTest.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? StateTableViewCell
           let actualReuseIdentifer = cell?.reuseIdentifier
           let expectedReuseIdentifier = "StateTableViewCell"
           XCTAssertEqual(actualReuseIdentifer, expectedReuseIdentifier)
    }
    
}
