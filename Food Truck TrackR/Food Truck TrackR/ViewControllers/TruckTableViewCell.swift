//
//  TruckTableViewCell.swift
//  Food Truck TrackR
//
//  Created by Elizabeth Thomas on 8/27/20.
//  Copyright © 2020 Juan M Mariscal. All rights reserved.
//

import UIKit

class TruckTableViewCell: UITableViewCell {

    @IBOutlet var truckNameLabel: UILabel!
    @IBOutlet var cuisineTypeLabel: UILabel!
    @IBOutlet var ratingLabel: UILabel!

    var truck: TruckRepresentation? {
        didSet {
            updateViews()
        }
    }

    private func updateViews() {
        truckNameLabel.text = truck?.name
        cuisineTypeLabel.text = truck?.cuisineType
        ratingLabel.text = String(describing: truck?.customerRatingAVG)
    }

//    override func awakeFromNib() {
//        super.awakeFromNib()
//    }

}
