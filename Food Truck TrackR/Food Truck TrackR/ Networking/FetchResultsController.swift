//
//  fetchResultsController.swift
//  Food Truck TrackR
//
//  Created by Craig Belinfante on 8/27/20.
//  Copyright © 2020 Juan M Mariscal. All rights reserved.
//

import Foundation
import CoreData



extension NetworkingController {
    
    // MARK: - Craig Work
    
    typealias CompletionHandler = (Result<Bool, NetworkingError>) -> Void
    
    //fetch movies
    func fetchTrucksFromServer(completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseUrl.appendingPathExtension("json")
        
        let task = URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                print("Error \(error)")
                completion(.failure(.noData))
                return
            }
            
            guard let data = data else {
                print("No data returned")
                completion(.failure(.noData))
                return
            }
            
            do {
                let truckRepresentations = Array(try JSONDecoder().decode([String: TruckRepresentation].self, from: data).values)
                try self.updateTrucks(with: truckRepresentations)
                completion(.success(true))
            } catch {
                print("Error \(error)")
                completion(.failure(.decodingError))
                return
            }
            
        }
        task.resume()
    }
    
    //Delete Movies
    func deleteTrucksFromServer(_ truck: Truck, completion: @escaping CompletionHandler = { _ in }) {
        let id = truck.identifier {
            completion(.failure(.noData))
            return
        }
        
        let requestURL = baseUrl.appendingPathComponent(id).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            print(response!)
            completion(.success(true))
        }
        task.resume()
    }
    
    func sendTrucksToServer(truck: Truck, completion: @escaping CompletionHandler = { _ in }) {
        
        let id = Int64 {
            completion(.failure(.noData))
            return
        }
        
        let requestURL = baseUrl.appendingPathComponent(id).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        
        request.httpMethod = "PUT"
        
        do {
            guard let representation = truck.truckRepresentation else {
                completion(.failure(.noData))
                return
            }
            
            request.httpBody = try JSONEncoder().encode(representation)
            
        } catch {
            print("Error encoding truck \(truck): \(error)")
            completion(.failure(.noData))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (_, _, error) in //normally has data, request, error
            if let error = error {
                print("Error \(error)")
                completion(.failure(.noData))
                return
            }
            
            completion(.success(true))
            
        }
        
        task.resume()
    }
    
    //Updating movies
    private func updateTrucks(with representations: [TruckRepresentation]) throws {
        let context = CoreDataStack.shared.container.newBackgroundContext()
        
        let identifiersToFetch = representations.compactMap({($0.identifier)})
        
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
        
        var trucksToAdd = representationsByID
        
        let fetchRequest: NSFetchRequest<Truck> = Truck.fetchRequest()
            
    
        fetchRequest.predicate = NSPredicate(format: "identifier in %@", identifiersToFetch)
        
        
        context.performAndWait {
            
            do {
                let existingTrucks = try context.fetch(fetchRequest)
                
                //update existing
                for truck in existingTrucks {
                    
                    let id = truck.identifier
                    guard let representation = representationsByID[Int(id)] else {
                            continue }
               
                    truck.name = representation.name
                    truck.location = representation.location
                    
                    trucksToAdd.removeValue(forKey: Int(id))
                }
                
                for representation in trucksToAdd.values {
                    Truck(truckRepresentation: representation, context: context)
                }
            
            } catch {
                print("Error fetching tasks for UUIDs: \(error)")
            }
        }
        
        try CoreDataStack.shared.save(context: context)
        
    }
}


