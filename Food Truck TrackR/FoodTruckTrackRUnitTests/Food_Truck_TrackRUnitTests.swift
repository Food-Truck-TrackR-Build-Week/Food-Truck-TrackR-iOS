//
//  Food_Truck_TrackRUnitTests.swift
//  Food Truck TrackRUITests
//
//  Created by Juan M Mariscal on 8/31/20.
//  Copyright © 2020 Juan M Mariscal. All rights reserved.
//

import XCTest
@testable import Food_Truck_TrackR

class Food_Truck_TrackRUnitTests: XCTestCase {

    func testGetTrucks() {
        let trucks = NetworkingController.shared.trucks
        XCTAssertTrue(trucks.count > 0)
    }
    
    func testLogIn() {
        
    }
    
    func testRating() {
        
    }
    
    func testRemovingTrucks() {
        
    }
    
    
    
}
