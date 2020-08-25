//
//  OperatorRepresentation.swift
//  Food Truck TrackR
//
//  Created by Elizabeth Thomas on 8/20/20.
//  Copyright © 2020 Juan M Mariscal. All rights reserved.
//

import Foundation

struct OperatorRepresentation: Codable {
    var identifier: String
    var userID: Double
    var username: String
    var password: String
    var email: String
    var trucksOwned: String?
}