//
//  TruckRepresentation.swift
//  Food Truck TrackR
//
//  Created by Michael McGrath on 8/26/20.
//  Copyright © 2020 Juan M Mariscal. All rights reserved.
//

import Foundation

struct TruckRepresentation: Codable {
    let identifier: Int
    let operatorID: Int

    let name: String
    let imageOfTruck: String?
    let location: String
    let cuisineType: String
    let departureTime: Int
    let customerRating: [Int]?
    let customerRatingAVG: Int?

    let menu: [MenuRepresentation]?

    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case operatorID = "operatorId"
        case name
        case imageOfTruck
        case location = "currentLocation"
        case cuisineType
        case departureTime
        case customerRating = "customerRatings"
        case customerRatingAVG = "customerRatingsAvg"
        case menu
    }
}


