//
//  CreateTruckViewController.swift
//  Food Truck TrackR
//
//  Created by Craig Belinfante on 8/30/20.
//  Copyright © 2020 Juan M Mariscal. All rights reserved.
//

import UIKit

class CreateTruckViewController: UIViewController {

    @IBOutlet weak var truckName: UITextField!
    @IBOutlet weak var addCuisine: UITextField!
    @IBOutlet weak var setTruckImage: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    func saveButton() {
        
    }
    
//    let moc = CoreDataStack.shared.mainContext
//    do {
//        try moc.save()
//    } catch {
//        print("Error saving \(error)")
//    }
    
}
