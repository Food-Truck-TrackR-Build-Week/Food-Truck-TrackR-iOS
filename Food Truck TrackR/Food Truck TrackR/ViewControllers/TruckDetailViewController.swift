//
//  TruckDetailViewController.swift
//  Food Truck TrackR
//
//  Created by Juan M Mariscal on 8/19/20.
//  Copyright © 2020 Juan M Mariscal. All rights reserved.
//

import UIKit

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
        guard let truck = truck else { return }
        //diner?.favoriteTrucks.append(truck)
    }

    // MARK: - Functions
    private func updateViews() {
      guard let truck = truck, let averageRating = truck.customerRatingAVG, let truckImage = truck.imageOfTruck else { return }
      foodTruckNameLabel.text = truck.name
      ratingLabel.text = String(describing: averageRating)
      // fetch image here
      //truckImageView.image = truckImage.toImage()
      cuisineTypeLabel.text = truck.cuisineType
      // Create string from date for departureTime
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "MMM d, h:mm a"
      departureTimeLabel.text = dateFormatter.string(from: Date(milliseconds: Int64(truck.departureTime)))
        reviewButton.layer.borderWidth = 2
        reviewButton.layer.borderColor = UIColor.orange.cgColor
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TruckRatingSegue"{
            guard let ratingVC = segue.destination as? TruckRatingViewController else { return }
            ratingVC.truck = truck
        } else { return }
    }
}
