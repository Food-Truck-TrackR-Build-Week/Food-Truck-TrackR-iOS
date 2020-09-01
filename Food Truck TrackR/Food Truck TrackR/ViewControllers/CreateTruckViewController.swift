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
    
    @IBAction func saveButton(_ sender: Any) {
        
         if truckName.text?.isEmpty ?? true {
               print("Empty")
            let alert = UIAlertController(title: title, message: "No Truck Created", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                        present(alert, animated: true)
           } else {
                print("Created new Truck")
                let alert = UIAlertController(title: title, message: "You created a new truck", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
                present(alert, animated: true)
               
          //  saveButton()
         //   performSegue(withIdentifier: "ProfileOperator", sender: self)
           }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
//    let moc = CoreDataStack.shared.mainContext
//    do {
//        try moc.save()
//    } catch {
//        print("Error saving \(error)")
//    }
    
}
