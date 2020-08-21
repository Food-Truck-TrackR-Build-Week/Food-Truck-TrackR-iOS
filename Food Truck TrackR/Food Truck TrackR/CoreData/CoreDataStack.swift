//
//  CoreDataStack.swift
//  Food Truck TrackR
//
//  Created by Craig Belinfante on 8/20/20.
//  Copyright © 2020 Juan M Mariscal. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    lazy var dinerContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Diner")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    lazy var operatorContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Operator")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    lazy var truckContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Truck")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    
    func saveDiner(context: NSManagedObjectContext = CoreDataStack.shared.dinerContext) throws {
        var error: Error?
        
        context.performAndWait {
            do {
                try context.save()
            } catch let saveError {
                error = saveError
            }
        }
        
        if let error = error { throw error }
    }
    
    func saveOperator(context: NSManagedObjectContext = CoreDataStack.shared.operatorContext) throws {
        var error: Error?
        
        context.performAndWait {
            do {
                try context.save()
            } catch let saveError {
                error = saveError
            }
        }
        
        if let error = error { throw error }
    }
    
    func saveTruck(context: NSManagedObjectContext = CoreDataStack.shared.truckContext) throws {
        var error: Error?
        
        context.performAndWait {
            do {
                try context.save()
            } catch let saveError {
                error = saveError
            }
        }
        
        if let error = error { throw error }
    }
    
    var dinerContext: NSManagedObjectContext {
        return dinerContainer.viewContext
    }
    var operatorContext: NSManagedObjectContext {
        return operatorContainer.viewContext
    }
    var truckContext: NSManagedObjectContext {
        return truckContainer.viewContext
    }
}

