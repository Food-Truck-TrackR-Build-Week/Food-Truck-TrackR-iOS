//
//  Diner+Convenience.swift
//  Food Truck TrackR
//
//  Created by Craig Belinfante on 8/23/20.
//  Copyright © 2020 Juan M Mariscal. All rights reserved.
//

import Foundation
import CoreData



extension Diner {
    
    var dinerRepresentation: DinerRepresentation? {
        guard let username = username, let password = password, let email = email, let favoriteTrucks = favoriteTrucks, let location = location else {return nil}
        
        return DinerRepresentation(identifier: identifier?.uuidString ?? "",
                                   userID: userID,
                                   username: username,
                                   password: password,
                                   email: email,
                                   favoriteTrucks: favoriteTrucks,
                                   location: location)
    }
    
    convenience init(identifier: UUID = UUID(),
                     userID: Double,
                     username: String,
                     password: String,
                     email: String,
                     favoriteTrucks: String? = nil,
                     location: String? = nil,
                     context: NSManagedObjectContext = CoreDataStack.shared.dinerContext) {
        self.init(context: context)
        self.identifier = identifier
        self.userID = userID
        self.username = username
        self.password = password
        self.email = email
        self.favoriteTrucks = favoriteTrucks
        self.location = location
    }
    
    @discardableResult convenience init?(dinerRepresentation: DinerRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.dinerContext) {
        guard let favoriteTrucks = dinerRepresentation.favoriteTrucks, let location = dinerRepresentation.location, let identifier = UUID(uuidString: dinerRepresentation.identifier) else {return nil}
        
        self.init(identifier: identifier,
                  userID: dinerRepresentation.userID,
                  username: dinerRepresentation.username,
                  password: dinerRepresentation.password,
                  email: dinerRepresentation.email,
                  favoriteTrucks: favoriteTrucks,
                  location: location,
                  context: context)
    }
}
