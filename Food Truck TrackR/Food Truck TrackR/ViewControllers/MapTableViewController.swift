//
//  MapTableViewController.swift
//  Food Truck TrackR
//
//  Created by Elizabeth Thomas on 8/20/20.
//  Copyright © 2020 Juan M Mariscal. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

// NO
class customPin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(titlePin: String, subtitlePin: String, coordinatePin: CLLocationCoordinate2D){
        self.title = titlePin
        self.subtitle = subtitlePin
        self.coordinate = coordinatePin
    }
}

class MapTableViewController: UITableViewController, MKMapViewDelegate {
    

    @IBAction func refresh(_ sender: Any) {
        networkController.getAllTrucks { (_) in
            DispatchQueue.main.async {
                self.refreshControl?.endRefreshing()
            }
        }
    }

    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000
    
    var trucks: [TruckRepresentation] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    let networkController = NetworkingController()
    var userIsLoggedIn: Bool = false
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        networkController.getAllTrucks { (result) in
            do {
                let allTrucks = try result.get()
                DispatchQueue.main.async {
                    self.trucks = allTrucks
                    self.tableView.reloadData()
                }
            } catch {
                if let error = error as? NetworkingError {
                    switch error {
                    case .noAuth:
                        NSLog("Error: No bearer token exists.")
                    case .badAuth:
                        NSLog("Error: Bearer token invalid.")
                    case .noData:
                        NSLog("Error: The response had no data.")
                    case .badData:
                        NSLog("Error: Corrupt data files.")
                    case .decodingError:
                        NSLog("Error: The data could not be decoded.")
                    case .encodingError:
                        NSLog("Error: The data could not be encoded.")
                    }
                }
            }
        }
        if !userIsLoggedIn {
            userIsLoggedIn = true
            performSegue(withIdentifier: .loginStoryboardSegue, sender: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
        mapView.showsCompass = true
        
        let foodTruckLocation = CLLocationCoordinate2D(latitude: 43.09306637904841, longitude: -77.65192094989914)
        let foodTruckPin = customPin(titlePin: "In Queso Emergency", subtitlePin: "A cheesy delight.", coordinatePin: foodTruckLocation)
        self.mapView.addAnnotation(foodTruckPin)
        self.mapView.delegate = self
        
        let foodTruckLocation2 = CLLocationCoordinate2D(latitude: 37.80128588094106, longitude: -122.42472711750167)
        let foodTruckPin2 = customPin(titlePin: "You Need Cheesus", subtitlePin: "A religous experience.", coordinatePin: foodTruckLocation2)
        self.mapView.addAnnotation(foodTruckPin2)
        self.mapView.delegate = self
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func mapView(_ mapview: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "customannotation")
        annotationView.image = UIImage(named: "Pin -cheap")
        annotationView.canShowCallout = true
        return annotationView
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trucks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        guard let cell = tableView.dequeueReusableCell(withIdentifier: "truckCell", for: indexPath) as? TruckTableViewCell else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: "truckCell", for: indexPath)
        
        let truck = trucks[indexPath.row]
        
        let titleText = "\(truck.name) \n\(truck.cuisineType)"
        cell.textLabel?.text = titleText
        cell.detailTextLabel?.text = "\(truck.customerRatingAVG ?? 0)"
        
        //        cell.truck = trucks[indexPath.row]
        
        return cell
    }
    
    
    // MARK: - MapKit Functions
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let pinLocation = view.annotation?.coordinate
        let userLocation = locationManager.location?.coordinate
        if pinLocation?.longitude == userLocation?.longitude &&
            pinLocation?.latitude == userLocation?.latitude {
            let zoomLocation = view.annotation?.coordinate
            focusMapOnUserLocation()
        } else if let pinLocation = view.annotation?.coordinate {
            focusMapOnPin(coord: pinLocation, regionMeters: regionInMeters / 2)
        }
    }
    
    func focusMapOnPin( coord: CLLocationCoordinate2D, regionMeters: Double ) {
        let region = MKCoordinateRegion.init(center: coord, latitudinalMeters: regionMeters, longitudinalMeters: regionMeters)
        mapView.setRegion(region, animated: true)
    }
    
    func focusMapOnUserLocation(){
        /* Zoom the map in around the location */
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    @IBAction func showLocationAlert() {
        let alertController = UIAlertController(title: "Enable Location Services",
                                                message: "To enable location service go to Settings > Privacy > Location Services",
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok",
                                                style: UIAlertAction.Style.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled(){
            //set up location manager
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            //show an alert
            showLocationAlert()
        }
    }
    
    func checkLocationAuthorization() {
        /* determines the location authorization settings of the user */
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            /* set up all the map stuff */
            mapView.showsUserLocation = true
            focusMapOnUserLocation()
            //            locationManager.startUpdatingLocation()
            break
        case .denied:
            /* user does not want their location to be known :(
             to fix they have to go through settings,
             set up alert to do that */
            showLocationAlert()
            break
        case .notDetermined:
            /* The user has not determined the location settings,
             so we ask them */
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            /* The user has something like child services on,
             show an alert to let them know */
            showLocationAlert()
            break
        case .authorizedAlways:
            /* The user has it set up so all apps can just work */
            break
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowProfile" {
            
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let detailVC = segue.destination as! TruckDetailViewController
            detailVC.truck = self.trucks[indexPath.row]
            
        } else if segue.identifier == .loginStoryboardSegue {
            
            let navVC = segue.destination as! UINavigationController
            let modalVC = navVC.topViewController as! ChooseUserTypeViewController
            navVC.presentationController?.delegate = modalVC
            modalVC.isModalInPresentation = true
            
        }
    }
    
    
}

extension MapTableViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else {return}
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}


