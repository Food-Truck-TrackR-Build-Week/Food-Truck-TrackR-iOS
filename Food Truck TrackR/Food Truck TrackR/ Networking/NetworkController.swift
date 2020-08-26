//
//  NetworkController.swift
//  Food Truck TrackR
//
//  Created by Eoin Lavery on 26/08/2020.
//  Copyright © 2020 Juan M Mariscal. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum NetworkingError: Error {
    case noAuth
    case badAuth
    case noData
    case badData
    case decodingError
}

class NetworkingController {
    let baseUrl = URL(string: "https://food-truck-trackr-api.herokuapp.com")!
    let token = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWJqZWN0IjoxMDAwMDEsInVzZXJuYW1lIjoiZGluZXIxIiwiaWF0IjoxNTk4MzE2NjA0LCJleHAiOjE1OTg0MDMwMDR9.aMZQvfWtHb-9Unn7CdS1q1Ouf0PyHSmdRqc_f_70Y78"
    
    let jsonDecoder = JSONDecoder()
    let jsonEncoder = JSONEncoder()
    
    //MARK: - GET Requests
    
    //returns an array of all trucks
    func getAllTrucks(completion: @escaping (Result<[TruckRepresentation], NetworkingError>) -> Void) {
        let reqEndpoint = "/api/trucks"
        let url = baseUrl.appendingPathComponent(reqEndpoint)
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if error != nil {
                print(error!)
                completion(.failure(.badAuth))
                return
            }
            
            guard let data = data else {
                NSLog("Unable to retrieve all trucks from server.")
                completion(.failure(.noData))
                return
            }
            
            do {
                let trucksArray = try self.jsonDecoder.decode([TruckRepresentation].self, from: data)
                completion(.success(trucksArray))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    //returns the truck with the given id
    func getTruck(for id: Int, completion: @escaping (Result<TruckRepresentation, NetworkingError>) -> Void) {
        let reqEndpoint = "/api/trucks/:\(id)"
        let url = baseUrl.appendingPathComponent(reqEndpoint)
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if error != nil {
                print(error!)
                completion(.failure(.badAuth))
                return
            }
            
            guard let data = data else {
                NSLog("Unable to retrieve truck with specified id: \(id)")
                completion(.failure(.noData))
                return
            }
            
            do {
                let truck = try self.jsonDecoder.decode(TruckRepresentation.self, from: data)
                completion(.success(truck))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    //returns an array of the menuItems from the menu for the truck with the given id
    func getTruckMenu(for id: Int, completion: @escaping (Result<MenuRepresentation, NetworkingError>) -> Void) {
        let reqEndpoint = "/api/trucks/:\(id)/menu"
        let url = baseUrl.appendingPathComponent(reqEndpoint)
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if error != nil {
                print(error!)
                completion(.failure(.badAuth))
                return
            }
            
            guard let data = data else {
                NSLog("Unable to retrieve menu items for truck with specified id: \(id)")
                completion(.failure(.noData))
                return
            }
            
            do {
                let menu = try self.jsonDecoder.decode(MenuRepresentation.self, from: data)
                completion(.success(menu))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    //returns the diner with the given id
    func getDiner(for id: Int, completion: @escaping (Result<DinerRepresentation, NetworkingError>) -> Void) {
        let reqEndpoint = "/api/diners/:\(id)"
        let url = baseUrl.appendingPathComponent(reqEndpoint)
        
        var request = URLRequest(url:url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if error != nil {
                print(error!)
                completion(.failure(.badAuth))
                return
            }
            
            guard let data = data else {
                NSLog("Unable to find diner with specified id: \(id)")
                completion(.failure(.noData))
                return
            }
            
            do {
                let diner = try self.jsonDecoder.decode(DinerRepresentation.self, from: data)
                completion(.success(diner))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    //returns an array of favoriteTrucks of the diner with the given id
    func getDinerFavoriteTrucks(for id: Int, completion: @escaping (Result<[TruckRepresentation], NetworkingError>) -> Void) {
        let reqEndpoint = "/api/diners/:\(id)/favoriteTrucks"
        let url = baseUrl.appendingPathComponent(reqEndpoint)
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, _, error ) in
            if error != nil {
                print(error!)
                completion(.failure(.badAuth))
                return
            }
            
            guard let data = data else {
                NSLog("Unable to find favoriteTrucks for diner with specified id: \(id)")
                completion(.failure(.noData))
                return
            }
            
            do {
                let trucks = try self.jsonDecoder.decode([TruckRepresentation].self, from: data)
                completion(.success(trucks))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    //returns the operator with the given id
    func getOperator(for id: Int, completion: @escaping (Result<OperatorRepresentation, NetworkingError>) -> Void) {
        let reqEndpoint = "/api/operators/:\(id)"
        let url = baseUrl.appendingPathComponent(reqEndpoint)
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if error != nil {
                print(error!)
                completion(.failure(.badAuth))
            }
            
            guard let data = data else {
                NSLog("Unable to find operator with specified id: \(id)")
                completion(.failure(.noData))
                return
            }
            
            do {
                let op = try self.jsonDecoder.decode(OperatorRepresentation.self, from: data)
                completion(.success(op))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    //returns an array of trucks owned by the operator with the given id
    func getOperatorTrucks(for id: Int, completion: @escaping (Result<[TruckRepresentation], NetworkingError>) -> Void) {
        let reqEndpoint = "/api/operators/:\(id)/trucksOwned"
        let url = baseUrl.appendingPathComponent(reqEndpoint)
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if error != nil {
                print(error!)
                completion(.failure(.badAuth))
            }
            
            guard let data = data else {
                NSLog("Unable to find trucks owned by operator with specified id: \(id)")
                completion(.failure(.noData))
                return
            }
            
            do {
                let trucks = try self.jsonDecoder.decode([TruckRepresentation].self, from: data)
                completion(.success(trucks))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}
