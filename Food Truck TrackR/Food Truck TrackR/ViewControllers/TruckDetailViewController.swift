//
//  TruckDetailViewController.swift
//  Food Truck TrackR
//
//  Created by Juan M Mariscal on 8/19/20.
//  Copyright © 2020 Juan M Mariscal. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class TruckDetailViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet var foodTruckNameLabel: UILabel!
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var truckImageView: UIImageView!
    @IBOutlet var currentLocationLabel: UILabel!
    @IBOutlet var cuisineTypeLabel: UILabel!
    @IBOutlet var departureTimeLabel: UILabel!
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet var favoriteButton: UIBarButtonItem!
    
    // MARK: - Properites
    
    var diner: Diner?
    var truck: TruckRepresentation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    // MARK: - IBActions
    @IBAction func favoriteButtonTapped(_ sender: Any) {
    }
    
    // MARK: - Functions
    
    func reverseGeocodeLocation(_ location: CLLocation, completionHandler: @escaping CLGeocodeCompletionHandler) {
        
        guard let truck = truck else {return}
        
        let location = truck.location
        
        print(location)
        
    }
    
    private func updateViews() {
        
        guard let truck = truck else {return}
        
        foodTruckNameLabel.text = truck.name
        cuisineTypeLabel.text = truck.cuisineType
        ratingLabel.text = String(describing: truck.customerRatingAVG ?? 0)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm a"
        departureTimeLabel.text = dateFormatter.string(from: Date(milliseconds: Int64(truck.departureTime)))
        reviewButton.layer.borderWidth = 2
        reviewButton.layer.borderColor = UIColor.orange.cgColor
        
        currentLocationLabel.text = truck.location
        
        truckImageView.image = UIImage(named: truck.imageOfTruck!)
    }
    //fix location and convert into address
    //    currentLocationLabel.text = truck.location
    //
    //        ratingLabel.text = String(describing: averageRating)
    //        // fetch image here
    //        truckImageView.image = UIImage(named: "https://firebasestorage.googleapis.com/v0/b/food-truck-tracker-a58d5.appspot.com/o/images%2F1C6B0AC0-0DFD-484B-9CDB-0BCB6A4F78FE?alt=media&token=31083c1d-a352-46b4-b493-bbb38c97da4e")
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TruckRatingSegue"{
            guard let ratingVC = segue.destination as? TruckRatingViewController else { return }
            ratingVC.truck = truck
        } else { return }
    }
}
