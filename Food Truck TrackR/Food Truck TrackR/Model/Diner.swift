//
//  DinerRepresentation.swift
//  Food Truck TrackR
//
//  Created by Elizabeth Thomas on 8/20/20.
//  Copyright © 2020 Juan M Mariscal. All rights reserved.
//

import Foundation

struct Diner: Codable {
    
    var dinerId: Int
    var username: String
    var email: String
    var currentLocation: String?

}
