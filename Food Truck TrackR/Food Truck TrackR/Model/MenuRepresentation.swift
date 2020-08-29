//
//  MenuRepresentation.swift
//  Food Truck TrackR
//
//  Created by Craig Belinfante on 8/24/20.
//  Copyright © 2020 Juan M Mariscal. All rights reserved.
//

import Foundation

struct MenuRepresentation: Codable {
    let id: Int
    let itemName: String
    let itemDescription: String
    let itemPrice: Double
    let itemPhotos: [String]?
    let customerRating: [Float]?
    let customerRatingAvg: Float?
}
