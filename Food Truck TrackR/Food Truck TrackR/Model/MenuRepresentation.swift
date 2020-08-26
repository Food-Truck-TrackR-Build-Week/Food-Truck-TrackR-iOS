//
//  MenuRepresentation.swift
//  Food Truck TrackR
//
//  Created by Craig Belinfante on 8/24/20.
//  Copyright © 2020 Juan M Mariscal. All rights reserved.
//

import Foundation

struct MenuRepresentation: Codable {
    var identifier: Int
    var menuID: Int
    var itemName: String
    var itemDescription: String
    var itemPrice: Double
    var itemPhotos: [String]?
}
