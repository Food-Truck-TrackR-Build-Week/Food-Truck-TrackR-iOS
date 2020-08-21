//
//  Truck.swift
//  Food Truck TrackR
//
//  Created by Elizabeth Thomas on 8/20/20.
//  Copyright © 2020 Juan M Mariscal. All rights reserved.
//

import Foundation
import UIKit

struct Truck {

    let id: Int
    let imageOfTruck: UIImage
    let cuisineType: String
    let currentLocation: String
    let departureTime: Date
    let operatorId: Int

    init(id: UUID = UUID(),
         imageOfTruck: UIImage,
         cuisineType: String,
         currentLocation: String,
         departureTime: Date = Date(),
         operatorId: Int) {
        self.id = id.hashValue
        self.imageOfTruck = imageOfTruck
        self.cuisineType = cuisineType
        self.currentLocation = currentLocation
        self.departureTime = departureTime
        self.operatorId = operatorId
    }

    

}
