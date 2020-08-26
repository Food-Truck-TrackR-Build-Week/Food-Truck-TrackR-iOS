//
//  TruckRepresentation.swift
//  Food Truck TrackR
//
//  Created by Elizabeth Thomas on 8/20/20.
//  Copyright © 2020 Juan M Mariscal. All rights reserved.
//

import Foundation

struct TruckRepresentation: Codable {
    var identifier: String
    var operatorID: Double
    var name: String
    var imageOfTruck: String //should this be of type URL?
    var location: String
    var cuisineType: String?
    var menu: String?
    var departureTime: Date
    var customerRating: Double?
    var customerRatingAVG: Double
}
