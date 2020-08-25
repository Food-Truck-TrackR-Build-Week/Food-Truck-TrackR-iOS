//
//  Truck+Convenience.swift
//  Food Truck TrackR
//
//  Created by Craig Belinfante on 8/23/20.
//  Copyright © 2020 Juan M Mariscal. All rights reserved.
//

import Foundation
import CoreData

extension Truck {
    
    var truckRepresentation: TruckRepresentation? {
        guard let name = name, let imageOfTruck = imageOfTruck, let location = location, let cuisineType = cuisineType, let menu = menu, let departureTime = departureTime else {return nil}
        
        return TruckRepresentation(identifier: identifier?.uuidString ?? "",
                                   operatorID: operatorID,
                                   name: name,
                                   imageOfTruck: imageOfTruck,
                                   location: location,
                                   cuisineType: cuisineType,
                                   menu: menu,
                                   departureTime: departureTime,
                                   customerRating: customerRating,
                                   customerRatingAVG: customerRatingAVG)
    }
    
    convenience init(identifier: UUID = UUID(),
                     operatorID: Double,
                     name: String,
                     imageOfTruck: String,
                     location: String,
                     cuisineType: String? = nil,
                     menu: String? = nil,
                     departureTime: Date,
                     customerRating: Double? = nil,
                     customerRatingAVG: Double,
                     context: NSManagedObjectContext = CoreDataStack.shared.truckContext) {
        self.init(context: context)
        self.identifier = identifier
        self.operatorID = operatorID
        self.name = name
        self.imageOfTruck = imageOfTruck
        self.location = location
        self.cuisineType = cuisineType
        self.menu = menu
        self.departureTime = departureTime
        self.customerRating = customerRating ?? 0
        self.customerRatingAVG = customerRatingAVG
    }
    
    @discardableResult convenience init?(truckRepresentation: TruckRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.truckContext) {
        
        guard let cuisineType = truckRepresentation.cuisineType, let menu = truckRepresentation.menu, let customerRating = truckRepresentation.customerRating, let identifier = UUID(uuidString: truckRepresentation.identifier) else {return nil}
        
        self.init(identifier: identifier,
                  operatorID: truckRepresentation.operatorID,
                  name: truckRepresentation.name,
                  imageOfTruck: truckRepresentation.imageOfTruck,
                  location: truckRepresentation.location,
                  cuisineType: cuisineType,
                  menu: menu,
                  departureTime: truckRepresentation.departureTime,
                  customerRating: customerRating,
                  customerRatingAVG: truckRepresentation.customerRatingAVG,
                  context: context)
    }
}
