//
//  TruckTableViewCell.swift
//  Food Truck TrackR
//
//  Created by Craig Belinfante on 8/27/20.
//  Copyright © 2020 Juan M Mariscal. All rights reserved.
//

import UIKit

class TruckTableViewCell: UITableViewCell {

    static let reuseIdentifier = "TruckCell"
    
    var truck: Truck? {
        didSet{
            updateViews()
        }
    }
    
    @IBOutlet weak var truckNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension TruckTableViewCell {

    func updateViews() {
        guard let truck = truck else {return}
        truckNameLabel.text = truck.name
    }
}
