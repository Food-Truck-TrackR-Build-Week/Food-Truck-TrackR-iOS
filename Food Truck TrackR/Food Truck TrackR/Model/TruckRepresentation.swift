//
//  TruckRepresentation.swift
//  Food Truck TrackR
//
//  Created by Michael McGrath on 8/26/20.
//  Copyright © 2020 Juan M Mariscal. All rights reserved.
//

import Foundation

struct TruckRepresentation: Codable {
    var identifier: Int
    var operatorID: Int
    var name: String
    var imageOfTruck: String?
    var location: String
    var cuisineType: String
    var menu: [MenuRepresentation]?
    var departureTime: Date
    var customerRating: [Double]?
    var customerRatingAVG: Double
}
