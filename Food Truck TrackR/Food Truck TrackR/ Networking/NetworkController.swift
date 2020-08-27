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
    case encodingError
}

class NetworkingController {
    
    let baseUrl = URL(string: "https://food-truck-trackr-api.herokuapp.com")!
    let token = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWJqZWN0IjoxMDAwMDEsInVzZXJuYW1lIjoiZGluZXIxIiwiaWF0IjoxNTk4MzE2NjA0LCJleHAiOjE1OTg0MDMwMDR9.aMZQvfWtHb-9Unn7CdS1q1Ouf0PyHSmdRqc_f_70Y78"
    
    let jsonDecoder = JSONDecoder()
    let jsonEncoder = JSONEncoder()
    
    //MARK: - POST Requests
    
    //returns diner and signs them into the app
    func loginDiner(completion: @escaping (Result<[TruckRepresentation], NetworkingError>) -> Void) {

        var semaphore = DispatchSemaphore (value: 0)

        let parameters = "{ \"username\": \"diner1\", \"password\": \"password\" }"
        let postData = parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "https://food-truck-trackr-api.herokuapp.com/api/auth/login")!,timeoutInterval: Double.infinity)
        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
          print(String(data: data, encoding: .utf8)!)
          semaphore.signal()
        }

        task.resume()
        semaphore.wait()

    }
    
    //returns diner and creates an account for them
    func registerDiner() {

        var semaphore = DispatchSemaphore (value: 0)

        let parameters = "{ \"username\": \"diner3\", \"password\": \"password\", \"email\": \"diner3@gmail.com\" }"
        let postData = parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "https://food-truck-trackr-api.herokuapp.com/api/auth/register/diner")!,timeoutInterval: Double.infinity)
        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
          print(String(data: data, encoding: .utf8)!)
          semaphore.signal()
        }

        task.resume()
        semaphore.wait()

    }
    
    //returns operator and signs them into the app
    func loginOperator(completion: @escaping (Result<[TruckRepresentation], NetworkingError>) -> Void) {
        
        var semaphore = DispatchSemaphore (value: 0)

        let parameters = "{ \"username\": \"diner1\", \"password\": \"password\" }"
        let postData = parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "https://food-truck-trackr-api.herokuapp.com/api/auth/login")!,timeoutInterval: Double.infinity)
        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
          print(String(data: data, encoding: .utf8)!)
          semaphore.signal()
        }

        task.resume()
        semaphore.wait()

    }
    
    //returns operator and creates an account for them
    func registerOperator() {
        
        let parameters = "{ \"username\": \"operator3\", \"password\": \"password\", \"email\": \"operator3@gmail.com\" }"
        let postData = parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "https://food-truck-trackr-api.herokuapp.com/api/auth/register/operator")!,timeoutInterval: Double.infinity)
        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
          print(String(data: data, encoding: .utf8)!)
          semaphore.signal()
        }

        task.resume()
        semaphore.wait()

        
    }
    
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
    
    //MARK: - DELETE Requests
    
    //deletes the truck with the given id
    func deleteTruck(for id: Int, completion: @escaping (Error?) -> Void) {
        let reqEndpoint = "/api/trucks/'\(id)"
        let url = baseUrl.appendingPathComponent(reqEndpoint)
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.delete.rawValue
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if error != nil {
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200:
                    print("Succeeded: Truck with ID: \(id) deleted successfully.")
                    completion(nil)
                case 400:
                    print("400 Error: Bad Request")
                    completion(error)
                case 403:
                    print("403 Error: Forbidden")
                    completion(error)
                case 404:
                    print("404 Error: Not Found")
                    completion(error)
                default:
                    print("\(response.statusCode) Error")
                    completion(error)
                }
            }
        }.resume()
    }
    
    //deletes the customerRating with the given ratingId from the truck with the given truckId
    func deleteTruckRating(for truckID: Int, with ratingID: Int, completion: @escaping (Error?) -> Void) {
        let reqEndpoint = "/api/trucks/:\(truckID)/customerRatings/:\(ratingID)"
        let url = baseUrl.appendingPathComponent(reqEndpoint)
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.delete.rawValue
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if error != nil {
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200:
                    print("Succeeded: Rating with ID: \(ratingID), for truck with ID: \(truckID) deleted successfully.")
                    completion(nil)
                case 400:
                    print("400 Error: Bad Request")
                    completion(error)
                case 403:
                    print("403 Error: Forbidden")
                    completion(error)
                case 404:
                    print("404 Error: Not Found")
                    completion(error)
                default:
                    print("\(response.statusCode) Error")
                    completion(error)
                }
            }
        }.resume()
    }
    
    //removes the menuItem with menuItemId from the menu with the menuId
    func removeMenuItem(for menuID: Int, with menuItemID: Int, completion: @escaping (Error?) -> Void) {
        let reqEndpoint = "/api/menus/:\(menuID)/menuItems/:\(menuItemID)"
        let url = baseUrl.appendingPathComponent(reqEndpoint)
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.delete.rawValue
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if error != nil {
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200:
                    print("Succeeded: Menu Item with ID: \(menuItemID), for Menu with ID: \(menuID) deleted successfully.")
                    completion(nil)
                case 400:
                    print("400 Error: Bad Request")
                    completion(error)
                case 403:
                    print("403 Error: Forbidden")
                    completion(error)
                case 404:
                    print("404 Error: Not Found")
                    completion(error)
                default:
                    print("\(response.statusCode) Error")
                    completion(error)
                }
            }
        }.resume()
    }
    
    //removes a url (string) from the itemPhotos array for the menuItem with the given id
    func removeMenuItemPhoto(for menuID: Int, with menuItemID: Int, with photoUrl: String, completion: @escaping (Result<[String],NetworkingError>) -> Void) {
        let reqEndpoint = "/api/menus/:\(menuID)/menuItems/:\(menuItemID)/itemPhotos"
        let url = baseUrl.appendingPathComponent(reqEndpoint)
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.delete.rawValue
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonBody = try jsonEncoder.encode(photoUrl)
            request.httpBody = jsonBody
        } catch {
            completion(.failure(.encodingError))
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print(error!)
                completion(.failure(.badAuth))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200:
                    print("Succeeded: Menu Item with ID: \(menuItemID), for Menu with ID: \(menuID) deleted successfully.")
                case 400:
                    print("400 Error: Bad Request")
                    completion(.failure(.badAuth))
                case 403:
                    print("403 Error: Forbidden")
                    completion(.failure(.badAuth))
                case 404:
                    print("404 Error: Not Found")
                    completion(.failure(.badAuth))
                default:
                    print("\(response.statusCode) Error")
                    completion(.failure(.badAuth))
                }
            }

            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let itemPhotos = try self.jsonDecoder.decode([String].self, from: data)
                completion(.success(itemPhotos))
            } catch {
                completion(.failure(.decodingError))
                return
            }
        }.resume()
    }
    
    //deletes the customerRating with the given ratingId from the menuItem with the given menuItemId
    func deleteMenuItemRating(for menuItemID: Int, with ratingID: Int, completion: @escaping (Error?) -> Void) {
        let reqEndpoint = "/api/menuItems/:\(menuItemID)/customerRatings/:\(ratingID)"
        let url = baseUrl.appendingPathComponent(reqEndpoint)
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.delete.rawValue
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if error != nil {
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200:
                    print("Succeeded: Rating with ID: \(ratingID), for MenuItem with ID: \(menuItemID) deleted successfully.")
                    completion(nil)
                case 400:
                    print("400 Error: Bad Request")
                    completion(error)
                case 403:
                    print("403 Error: Forbidden")
                    completion(error)
                case 404:
                    print("404 Error: Not Found")
                    completion(error)
                default:
                    print("\(response.statusCode) Error")
                    completion(error)
                }
            }
        }.resume()
    }
    
    //deletes a truck from the array of favoriteTrucks of the diner with the given id
    func deleteDinerFavoriteTruck(for dinerID: Int, with truckID: Int, completion: @escaping (Result<[TruckRepresentation], NetworkingError>) -> Void) {
        let reqEndpoint = "/api/diners/:\(dinerID)/favoriteTrucks"
        let url = baseUrl.appendingPathComponent(reqEndpoint)
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.delete.rawValue
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonBody = try jsonEncoder.encode(truckID)
            request.httpBody = jsonBody
        } catch {
            completion(.failure(.encodingError))
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                completion(.failure(.badAuth))
            }
            
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200:
                    print("Succeeded: Truck with ID: \(truckID), for Diner with ID: \(dinerID) deleted successfully.")
                case 400:
                    print("400 Error: Bad Request")
                    completion(.failure(.badAuth))
                case 403:
                    print("403 Error: Forbidden")
                    completion(.failure(.badAuth))
                case 404:
                    print("404 Error: Not Found")
                    completion(.failure(.badAuth))
                default:
                    print("\(response.statusCode) Error")
                    completion(.failure(.badAuth))
                }
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let trucks = try self.jsonDecoder.decode([TruckRepresentation].self, from: data)
                completion(.success(trucks))
            } catch {
                completion(.failure(.decodingError))
                return
            }
        }.resume()
    }
}
