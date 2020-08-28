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
    @IBOutlet var favoriteButton: UIBarButtonItem!

    // MARK: - Properites
    var diner: DinerRepresentation?
    var truck: TruckRepresentation?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }

    // MARK: - IBActions
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        guard let truck = truck else { return }
        diner?.favoriteTrucks?.append(truck)
    }

    // MARK: - Functions
    private func updateViews() {
        foodTruckNameLabel.text = truck?.name
        ratingLabel.text = String(describing: truck?.customerRatingAVG)
        // fetch image here
        currentLocationLabel.text = truck?.location
        cuisineTypeLabel.text = truck?.cuisineType

        // Create string from date for departureTime
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm a"

        guard let departureTime = truck?.departureTime else { return }

        departureTimeLabel.text = dateFormatter.string(from: Date(milliseconds: Int64(departureTime)))
    }
}
