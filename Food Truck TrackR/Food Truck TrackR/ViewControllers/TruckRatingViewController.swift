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
    
    var networkController: NetworkingController?
    
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
