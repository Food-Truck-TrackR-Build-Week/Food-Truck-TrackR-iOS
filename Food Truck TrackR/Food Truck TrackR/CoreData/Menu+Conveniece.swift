//
//  Menu+Conveniece.swift
//  Food Truck TrackR
//
//  Created by Craig Belinfante on 8/24/20.
//  Copyright © 2020 Juan M Mariscal. All rights reserved.
//

import Foundation
import CoreData

extension Menu {
    
    var menuRepresentation: MenuRepresentation? {
        guard let itemName = itemName, let itemDescription = itemDescription, let itemPhotos = itemPhotos else {return nil}
        
        return MenuRepresentation(id: Int(menuID),
                                  itemName: itemName,
                                  itemDescription: itemDescription,
                                  itemPrice: itemPrice,
                                  itemPhotos: itemPhotos,
                                  customerRating: [5],
                                  customerRatingAvg: 5)
    }
    
    convenience init(identifier: Int64,
                     menuID: Int64,
                     itemName: String,
                     itemDescription: String,
                     itemPrice: Double,
                     itemPhotos: [String]? = nil,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.identifier = identifier
        self.menuID = menuID
        self.itemName = itemName
        self.itemDescription = itemDescription
        self.itemPrice = itemPrice
        self.itemPhotos = itemPhotos
    }
    
    @discardableResult convenience init?(menuRepresentation: MenuRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let itemPhotos = menuRepresentation.itemPhotos else {return nil}
        
        self.init(identifier: Int64(menuRepresentation.id),
                  menuID: Int64(menuRepresentation.id),
                  itemName: menuRepresentation.itemName,
                  itemDescription: menuRepresentation.itemDescription,
                  itemPrice: menuRepresentation.itemPrice,
                  itemPhotos: itemPhotos)
    }
}
