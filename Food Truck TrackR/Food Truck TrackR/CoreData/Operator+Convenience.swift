//
//  Operator+Convenience.swift
//  Food Truck TrackR
//
//  Created by Craig Belinfante on 8/24/20.
//  Copyright © 2020 Juan M Mariscal. All rights reserved.
//

import Foundation
import CoreData

extension Operator {
    
    var operatorRepresentation: OperatorRepresentation? {
        guard let username = username, let password = password, let email = email, let trucksOwned = trucksOwned else {return nil}
        
        return OperatorRepresentation(identifier: identifier?.uuidString ?? "",
                                      userID: userID,
                                      username: username,
                                      password: password,
                                      email: email,
                                      trucksOwned: trucksOwned)
    }
    
    convenience init(identifier: UUID = UUID(),
                     userID: Double,
                     username: String,
                     password: String,
                     email: String,
                     trucksOwned: String? = nil,
                     context: NSManagedObjectContext = CoreDataStack.shared.operatorContext) {
        self.init(context: context)
        self.identifier = identifier
        self.userID = userID
        self.username = username
        self.password = password
        self.email = email
        self.trucksOwned = trucksOwned
    }
    
    @discardableResult convenience init?(operatorRepresentation: OperatorRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.operatorContext) {
        guard let trucksOwned = operatorRepresentation.trucksOwned, let identifier = UUID(uuidString: operatorRepresentation.identifier) else {return nil}
        
        self.init(identifier: identifier,
                  userID: operatorRepresentation.userID,
                  username: operatorRepresentation.username,
                  password: operatorRepresentation.password,
                  email: operatorRepresentation.email,
                  trucksOwned: trucksOwned,
                  context: context)
    }
}
