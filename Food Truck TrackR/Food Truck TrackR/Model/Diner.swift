//
//  Diner.swift
//  Food Truck TrackR
//
//  Created by Elizabeth Thomas on 8/20/20.
//  Copyright © 2020 Juan M Mariscal. All rights reserved.
//

import Foundation

struct DinerRepresentation {

    let userId: Int
    let username: String
    let password: String
    let email: String
    let currentLocation: String

    init(userId: UUID = UUID(),
         username: String,
         password: String,
         email: String,
         currentLocation: String) {
        self.userId = userId.hashValue
        self.username = username
        self.password = password
        self.email = email
        self.currentLocation = currentLocation
    }

}
