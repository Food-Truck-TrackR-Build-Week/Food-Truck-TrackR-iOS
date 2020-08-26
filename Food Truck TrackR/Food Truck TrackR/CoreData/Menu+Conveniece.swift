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
        
        return MenuRepresentation(identifier: identifier?.uuidString ?? "",
                                  menuID: menuID,
                                  itemName: itemName,
                                  itemDescription: itemDescription,
                                  itemPrice: itemPrice,
                                  itemPhotos: itemPhotos)
    }
    
    convenience init(identifier: UUID = UUID(),
                     menuID: Double,
                     itemName: String,
                     itemDescription: String,
                     itemPrice: Double,
                     itemPhotos: String? = nil,
                     context: NSManagedObjectContext = CoreDataStack.shared.menuContext) {
        self.init(context: context)
        self.identifier = identifier
        self.menuID = menuID
        self.itemName = itemName
        self.itemDescription = itemDescription
        self.itemPrice = itemPrice
        self.itemPhotos = itemPhotos
    }
    
    @discardableResult convenience init?(menuRepresentation: MenuRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.menuContext) {
        guard let itemPhotos = menuRepresentation.itemPhotos, let identifier = UUID(uuidString: menuRepresentation.identifier) else {return nil}
        
        self.init(identifier: identifier,
                  menuID: menuRepresentation.menuID,
                  itemName: menuRepresentation.itemName,
                  itemDescription: menuRepresentation.itemDescription,
                  itemPrice: menuRepresentation.itemPrice,
                  itemPhotos: itemPhotos)
    }
}
