//
//  NetworkController.swift
//  Food Truck TrackR
//
//  Created by Eoin Lavery on 26/08/2020.
//  Copyright © 2020 Juan M Mariscal. All rights reserved.
//

import Foundation

//This will be used to help check if the login credentials were invalid
struct LoginError: Codable {
    var message: String
}

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
    case invalidCredentials
    case existingAccount
}

class NetworkingController {
    
    //MARK: - Properties
    static let shared = NetworkingController()
    
    let baseUrl = URL(string: "https://food-truck-trackr-api.herokuapp.com")!
    var token = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWJqZWN0IjoxMDAwMDUsInVzZXJuYW1lIjoibWlndWVsaXRvN0BnbWFpbC5jb20iLCJpYXQiOjE1OTg3MjI5MzUsImV4cCI6MTU5ODgwOTMzNX0.E8Ih5mWe5CoszPF5OclFqqUwe2mBzdSRzOVJVAQOePI"
    
    let jsonDecoder = JSONDecoder()
    let jsonEncoder = JSONEncoder()
    
    //These properties will be used to store the user's infromation during the app's lifecycle
    
    //Use this to identify which type of user is logged in
    var loggedInUserType: UserType?
    
    //Use these to know what kind of work you are doing (based on who the current logged in user is)
    var diner: Diner?
    var `operator`: Operator?
    var dinerRep: DinerRepresentaion? {
        didSet {
            diner = dinerRep!.diner
            token = "Bearer " + dinerRep!.token
            loggedInUserType = .diner
            self.getDinerFavoriteTrucks(for: diner!.dinerId) { (result) in
                do {
                    self.trucks = try result.get()
                    print("NOTIFICATION: favorite trucks acquired")
                } catch {
                    print("ERROR: Could not retrieve list of favorite trucks: \(error)")
                }
            }
        }
    }
    var operatorRep: OperatorRepresentation? {
        didSet {
            `operator` = operatorRep?.operator
            token = "Bearer " + operatorRep!.token
            loggedInUserType = .operator
            getOperatorTrucks(for: `operator`!.operatorId) { (result) in
                do {
                    self.trucks = try result.get()
                    print("NOTIFICATION: Owned trucks acquired")
                } catch {
                    print("ERROR: Could not retrieve list of owned trucks: \(error)")
                }
            }
        }
    }
    
    //This property will be used to store an array of trucks for the logged in user (Diner or Operator)
    var trucks: [TruckRepresentation] = []
    
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
            
            let json = try! JSONSerialization.jsonObject(with: data, options: [])
            print(json)
            do {
                let trucksArray = try self.jsonDecoder.decode([TruckRepresentation].self, from: data)
                completion(.success(trucksArray))
            } catch {
                NSLog("\(error)")
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
    func getDiner(for id: Int, completion: @escaping (Result<Diner, NetworkingError>) -> Void) {
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
                let diner = try self.jsonDecoder.decode(Diner.self, from: data)
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
    func getOperator(for id: Int, completion: @escaping (Result<Operator, NetworkingError>) -> Void) {
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
                let op = try self.jsonDecoder.decode(Operator.self, from: data)
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
    
    //MARK: - POST Requests -
    
    struct CreateDinerBody: Codable {
        let username: String
        let password: String
        let email: String
    }
    
    //creates a new diner
    func createDiner(with username: String, password: String, email: String, currentLocation: String?, completion: @escaping (Result<Diner, NetworkingError>) -> Void) {
        let reqEndpoint = "/api/auth/register/diner"
        let url = baseUrl.appendingPathComponent(reqEndpoint)
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonObject = CreateDinerBody(username: username, password: password, email: email)
        
        do {
            let jsonBody = try jsonEncoder.encode(jsonObject)
            request.httpBody = jsonBody
        } catch {
            completion(.failure(.encodingError))
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if error != nil {
                completion(.failure(.badAuth))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let errorMessage = try self.jsonDecoder.decode(LoginError.self, from: data)
                print(errorMessage)
                completion(.failure(.existingAccount))
                return
            } catch {
                print("Login credentials were valid")
            }
            
            do {
                let newDiner = try self.jsonDecoder.decode(Diner.self, from: data)
                completion(.success(newDiner))
            } catch {
                completion(.failure(.decodingError))
                return
            }
        }.resume()
    }
    
    struct CreateOperatorBody: Codable {
        let username: String
        let password: String
        let email: String
    }
    
    //creates a new operator
    func createOperator(with username: String, password: String, email: String, completion: @escaping (Result<Operator, NetworkingError>) -> Void) {
        let reqEndpoint = "/api/auth/register/operator"
        let url = baseUrl.appendingPathComponent(reqEndpoint)
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonObject = CreateOperatorBody(username: username, password: password, email: email)
        
        do {
            let jsonBody = try jsonEncoder.encode(jsonObject)
            request.httpBody = jsonBody
        } catch {
            completion(.failure(.encodingError))
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if error != nil {
                completion(.failure(.badAuth))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let possibleInvalidCredentialsError = try self.jsonDecoder.decode(LoginError.self, from: data)
                print(possibleInvalidCredentialsError)
                completion(.failure(.existingAccount))
                return
            } catch {
                print("Login credentials were valid")
            }
            
            do {
                let newOperator = try self.jsonDecoder.decode(Operator.self, from: data)
                completion(.success(newOperator))
            } catch {
                completion(.failure(.decodingError))
                return
            }
        }.resume()
    }
    
    struct LoginJSONObject: Codable {
        let username: String
        let password: String
    }
    
    //logs in as diner
    func loginDiner(with username: String, password: String, completion: @escaping (Result<DinerRepresentaion, NetworkingError>) -> Void) {
        let reqEndpoint = "/api/auth/login"
        let url = baseUrl.appendingPathComponent(reqEndpoint)
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonObject = LoginJSONObject(username: username, password: password)
        
        do {
            let jsonBody = try jsonEncoder.encode(jsonObject)
            request.httpBody = jsonBody
        } catch {
            completion(.failure(.encodingError))
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if error != nil {
                completion(.failure(.badAuth))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            //Testing if the login credentials were valid
            do {
                let possibleInvalidCredentialsError = try self.jsonDecoder.decode(LoginError.self, from: data)
                print(possibleInvalidCredentialsError)
                completion(.failure(.invalidCredentials))
                return
            } catch {
                print("Login credentials were valid")
            }
            
            do {
                let diner = try self.jsonDecoder.decode(DinerRepresentaion.self, from: data)
                completion(.success(diner))
            } catch {
                completion(.failure(.decodingError))
                return
            }
        }.resume()
    }
    
    //logs in as operator
    func loginOperator(with username: String, password: String, completion: @escaping (Result<OperatorRepresentation, NetworkingError>) -> Void) {
        let reqEndpoint = "/api/auth/login"
        let url = baseUrl.appendingPathComponent(reqEndpoint)
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonObject = LoginJSONObject(username: username, password: password)
        
        do {
            let jsonBody = try jsonEncoder.encode(jsonObject)
            request.httpBody = jsonBody
        } catch {
            completion(.failure(.encodingError))
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if error != nil {
                completion(.failure(.badAuth))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            //Testing if the login credentials were valid
            do {
                let possibleInvalidCredentialsError = try self.jsonDecoder.decode(LoginError.self, from: data)
                print(possibleInvalidCredentialsError)
                completion(.failure(.invalidCredentials))
                return
            } catch {
                print("Login credentials were valid")
            }
            
            do {
                let op = try self.jsonDecoder.decode(OperatorRepresentation.self, from: data)
                completion(.success(op))
            } catch {
                completion(.failure(.decodingError))
                return
            }
        }.resume()
    }
    
    struct CreateTruckBody: Codable {
        let name: String
        let imageOfTruck: String
        let cuisineType: String
        let currentLocation: String
        let operatorID: String
        let departureTime: String?
    }
    
    //creates a new truck
    func createTruck(with name: String, imageOfTruck: String, cuisineType: String, currentLocation: String, operatorID: String, departureTime: String?, completion: @escaping (Result<TruckRepresentation, NetworkingError>) -> Void) {
        let reqEndpoint = "/api/trucks"
        let url = baseUrl.appendingPathComponent(reqEndpoint)
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonObject = CreateTruckBody(name: name, imageOfTruck: imageOfTruck, cuisineType: cuisineType, currentLocation: currentLocation, operatorID: operatorID, departureTime: departureTime ?? String(describing: Date()))
        
        do {
            let jsonBody = try jsonEncoder.encode(jsonObject)
            request.httpBody = jsonBody
        } catch {
            completion(.failure(.encodingError))
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if error != nil {
                completion(.failure(.badAuth))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let newTruck = try self.jsonDecoder.decode(TruckRepresentation.self, from: data)
                completion(.success(newTruck))
            } catch {
                completion(.failure(.decodingError))
                return
            }
        }.resume()
    }
    
    struct CreateMenuItem: Codable {
        let itemName: String
        let itemDescription: String
        let itemPrice: Double
    }
    
    //adds a menuItem to the menu for the truck with the given id
    func createMenuItem(for truckID: Int, with itemName: String, itemDescription: String, itemPrice: Double, completion: @escaping (Result<MenuRepresentation, NetworkingError>) -> Void) {
        let reqEndpoint = "/api/trucks/:\(truckID)/menu"
        let url = baseUrl.appendingPathComponent(reqEndpoint)
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonObject = CreateMenuItem(itemName: itemName, itemDescription: itemDescription, itemPrice: itemPrice)
        
        do {
            let jsonBody = try jsonEncoder.encode(jsonObject)
            request.httpBody = jsonBody
        } catch {
            completion(.failure(.encodingError))
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if error != nil {
                completion(.failure(.badAuth))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let newMenuItem = try self.jsonDecoder.decode(MenuRepresentation.self, from: data)
                completion(.success(newMenuItem))
            } catch {
                completion(.failure(.decodingError))
                return
            }
        }.resume()
    }
    
    //adds (or replaces) a customerRating for the truck with the given truckId associated with the diner with the given dinerId
    func addCustomerRating(for truckID: Int, with dinerID: Int, customerRating: Double, completion: @escaping (Result<Double, NetworkingError>) -> Void) {
        let reqEndpoint = "/api/trucks/:\(truckID)/customerRatings/:\(dinerID)"
        let url = baseUrl.appendingPathComponent(reqEndpoint)
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonBody = try jsonEncoder.encode(customerRating)
            request.httpBody = jsonBody
        } catch {
            completion(.failure(.encodingError))
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if error != nil {
                completion(.failure(.badAuth))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let newRating = try self.jsonDecoder.decode(Double.self, from: data)
                completion(.success(newRating))
            } catch {
                completion(.failure(.decodingError))
                return
            }
        }.resume()
    }
    
    //adds a url (string) to the itemPhotos array for the menuItem with the given id
    func addMenuItemPhoto(for truckID: Int, with menuItemID: Int, photoUrl: String, completion: @escaping (Result<[String], NetworkingError>) -> Void) {
        let reqEndpoint = "/api/trucks/:\(truckID)/menu/:\(menuItemID)/itemPhotos"
        let url = baseUrl.appendingPathComponent(reqEndpoint)
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonBody = try jsonEncoder.encode(photoUrl)
            request.httpBody = jsonBody
        } catch {
            completion(.failure(.encodingError))
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if error != nil {
                completion(.failure(.badAuth))
                return
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
    
    //restricted, adds a truck to the array of favoriteTrucks of the diner with the given id
    func addFavoriteTruck(for dinerID: Int, with truckID: Int, completion: @escaping (Result<[TruckRepresentation], NetworkingError>) -> Void) {
        let reqEndpoint = "/api/diners/:\(dinerID)/favoriteTrucks"
        let url = baseUrl.appendingPathComponent(reqEndpoint)
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonBody = try jsonEncoder.encode(truckID)
            request.httpBody = jsonBody
        } catch {
            completion(.failure(.encodingError))
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if error != nil {
                completion(.failure(.badAuth))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let itemPhotos = try self.jsonDecoder.decode([TruckRepresentation].self, from: data)
                completion(.success(itemPhotos))
            } catch {
                completion(.failure(.decodingError))
                return
            }
        }.resume()
    }
    
    //MARK: - PUT Requests
    
    //updates the truck with the given id
    func updateTruck(for truckID: Int, with truck: TruckRepresentation, completion: @escaping (Error?) -> Void) {
        let reqEndpoint = "/api/trucks/:\(truckID)"
        let url = baseUrl.appendingPathComponent(reqEndpoint)
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.put.rawValue
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonBody = try jsonEncoder.encode(truck)
            request.httpBody = jsonBody
        } catch {
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (_, response, error) in
            if error != nil {
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200:
                    print("Succeeded: Truck with ID: \(truckID) updated siccessfully.")
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
    
    //updates the menuItem with the given menuItemId
    func updateMenuItem(for truckID: Int, with menuItemID: Int, menuItem: MenuRepresentation,completion: @escaping (Result<MenuRepresentation, NetworkingError>) -> Void) {
        let reqEndpoint = "/api/trucks/:\(truckID)/menu/:\(menuItemID)"
        let url = baseUrl.appendingPathComponent(reqEndpoint)
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.put.rawValue
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonBody = try jsonEncoder.encode(menuItem)
            request.httpBody = jsonBody
        } catch {
            completion(.failure(.encodingError))
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if error != nil {
                completion(.failure(.badAuth))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let menuItem = try self.jsonDecoder.decode(MenuRepresentation.self, from: data)
                completion(.success(menuItem))
            } catch {
                completion(.failure(.decodingError))
                return
            }
        }.resume()
    }
    
    //updates the currentLocation of the diner with the given id
    func updateDinerLocation(for dinerID: Int, with currentLocation: String,completion: @escaping (Result<Diner, NetworkingError>) -> Void) {
        let reqEndpoint = "/api/diners/\(dinerID)"
        let url = baseUrl.appendingPathComponent(reqEndpoint)
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.put.rawValue
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonBody = try jsonEncoder.encode(currentLocation)
            request.httpBody = jsonBody
        } catch {
            completion(.failure(.encodingError))
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if error != nil {
                completion(.failure(.badAuth))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let diner = try self.jsonDecoder.decode(Diner.self, from: data)
                completion(.success(diner))
            } catch {
                completion(.failure(.decodingError))
                return
            }
        }.resume()
    }
    
}
