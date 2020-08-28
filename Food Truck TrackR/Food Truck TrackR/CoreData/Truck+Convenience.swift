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
        guard let name = name, let imageOfTruck = imageOfTruck, let location = location, let cuisineType = cuisineType else {return nil}

        var menuItems: [MenuRepresentation] = []

        if let items = menu {
            for item in items {
                if let menuItem = item as? Menu, let menuItemRepresentation = menuItem.menuRepresentation {
                    menuItems.append(menuItemRepresentation)
                }
            }
        }

        var date: Int = 0
        if let interval = departureTime?.millisecondsSince1970 {
            date = Int(interval)
        }

        return TruckRepresentation(identifier: Int(identifier),
                                   operatorID: Int(operatorID),
                                   name: name,
                                   imageOfTruck: imageOfTruck,
                                   location: location,
                                   cuisineType: cuisineType,
                                   departureTime: date,
                                   customerRating: customerRating,
                                   customerRatingAVG: Int(customerRatingAVG),
                                   menu: menuItems)
    }

    convenience init(identifier: Int64,
                     operatorID: Int64,
                     name: String,
                     imageOfTruck: String?,
                     location: String,
                     cuisineType: String,
                     menu: NSSet?,
                     departureTime: Date,
                     customerRating: [Int]?,
                     customerRatingAVG: Int64,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.identifier = identifier
        self.operatorID = operatorID
        self.name = name
        self.imageOfTruck = imageOfTruck
        self.location = location
        self.cuisineType = cuisineType
        self.menu = menu
        self.departureTime = departureTime
        self.customerRating = customerRating
        self.customerRatingAVG = customerRatingAVG
    }

    @discardableResult convenience init?(truckRepresentation: TruckRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {

        guard let imageOfTruck = truckRepresentation.imageOfTruck else {return nil}

        var menuItems: [Menu] = []

        if let itemMenuRepresentation = truckRepresentation.menu, itemMenuRepresentation.count > 0 {
            for representation in itemMenuRepresentation {
                if let item = Menu(menuRepresentation: representation) {
                    menuItems.append(item)
                }
            }
        }

        let departureTime = Date(milliseconds: Int64(truckRepresentation.departureTime))

        var menuSet: NSSet?

        if menuItems.count > 0 {
            menuSet = NSSet(array: [menuItems])
        }

        self.init(identifier: Int64(truckRepresentation.identifier),
                  operatorID: Int64(truckRepresentation.operatorID),
                  name: truckRepresentation.name,
                  imageOfTruck: imageOfTruck,
                  location: truckRepresentation.location,
                  cuisineType: truckRepresentation.cuisineType,
                  menu: menuSet,
                  departureTime: departureTime,
                  customerRating: truckRepresentation.customerRating,
                  customerRatingAVG: Int64(truckRepresentation.customerRatingAVG ?? 0),
                  context: context)
    }
}
