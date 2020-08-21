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
    @IBOutlet var firstReviewLabel: UILabel!
    @IBOutlet var secondReviewLabel: UILabel!
    @IBOutlet var thirdReviewLabel: UILabel!
    @IBOutlet var favoriteButton: UIButton!

    // MARK: - Properites

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: - IBActions
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        favoriteButton.setImage(UIImage(named: "heart.fill"), for: .normal)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
