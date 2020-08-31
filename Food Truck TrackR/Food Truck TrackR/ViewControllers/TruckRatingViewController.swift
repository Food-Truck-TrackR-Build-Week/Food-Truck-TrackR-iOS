//
//  TruckRatingViewController.swift
//  Food Truck TrackR
//
//  Created by Gladymir Philippe on 8/21/20.
//  Copyright © 2020 Juan M Mariscal. All rights reserved.
//

import UIKit

class TruckRatingViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var truckNameLabel: UILabel!
    @IBOutlet weak var truckImage: UIImageView!
    
    var networkController = NetworkingController.shared
    
    var truck: TruckRepresentation? {
        didSet {
            updateViews()
        }
    }
    var diner: Diner?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    func updateViews() {
        guard isViewLoaded else { return }
        
        guard let truck = truck else {
            title = "Review Food Truck"
            
            truckNameLabel.text = "Food Truck"
            return
        }
        
        title = "Review Food Truck"
        truckNameLabel.text = "\(truck.name)"
        
        //updateImage()
        truckImage.image = UIImage(named: "https://firebasestorage.googleapis.com/v0/b/food-truck-tracker-a58d5.appspot.com/o/images%2F1C6B0AC0-0DFD-484B-9CDB-0BCB6A4F78FE?alt=media&token=31083c1d-a352-46b4-b493-bbb38c97da4e")
        
        
    }
    
    // MARK: - IBActions
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let truck = truck else { return }
        guard let diner = diner else { return }
        
//        networkController?.addCustomerRating(for: truckId, with: dinerId, customerRating: 2, completion: { (result, error) in
//
//        })
    }
    
    
    @IBAction func updateRating(_ ratingControl: CustomControl) {
        title = "Diner Rating: \(ratingControl.value) stars"
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
