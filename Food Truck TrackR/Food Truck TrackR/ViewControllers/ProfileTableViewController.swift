//
//  ProfileTableViewController.swift
//  Food Truck TrackR
//
//  Created by Craig Belinfante on 8/30/20.
//  Copyright © 2020 Juan M Mariscal. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {
    
  //  let networkController = NetworkingController()
    
    // MARK - Properties
    
    //    var userType: UserType? {
    //        didSet {
    //            print("user type has been set to: \(userType!.rawValue)")
    //        }
    //    }
    
    let networkController = NetworkingController.shared
    
    var diner: Diner?
    var allTrucks: [TruckRepresentation] = []
    var truck: TruckRepresentation?
    
    var userType: UserType? {
           didSet {
               print("user type has been set to: \(userType!.rawValue)")
           }
       }
    
    // Mark - Outlets
    
    @IBOutlet weak var truckProfilePicture: UIImageView!
    @IBOutlet weak var userProfilePicture: UIImageView!
    @IBOutlet weak var truckNameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  updateViews()
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allTrucks.count
        //dinerfavoriteTrucks.count ?? 0
    }
    
    //     func prepare(for segue: UIStoryboardSegue, sender: UIBarButtonItem?) {
    //         let vc = segue.destination as! ProfileTableViewController
    //
    //               if segue.identifier ==  "OperatorSegue" {
    //                   vc.userType = .operator
    //
    //               } else if segue.identifier == "DinerSegue" {
    //                   vc.userType = .diner
    //
    //               }
    //    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TruckCell", for: indexPath)
        
        let trucks = allTrucks[indexPath.row]
        
        let truckName = "Name- \(trucks.name)"
        cell.textLabel?.text = truckName
        
        return cell
    }
    
    private func updateViews() {
        
     //   guard let diner = diner, let truck = truck else {return}
        guard let diner = diner else {return}
        
        //Labels
       // truckNameLabel.text = truck?.name
        truckNameLabel.text = truck?.name
            //diner?.username
      //  nameProfileDescription.text =
        
        
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

