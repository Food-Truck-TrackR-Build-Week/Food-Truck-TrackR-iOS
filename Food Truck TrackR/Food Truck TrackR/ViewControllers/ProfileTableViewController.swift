//
//  ProfileTableViewController.swift
//  Food Truck TrackR
//
//  Created by Craig Belinfante on 8/30/20.
//  Copyright © 2020 Juan M Mariscal. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {
    
    let networkController = NetworkingController()
    
   // MARK - Properties
    
    var userType: UserType? {
        didSet {
            print("user type has been set to: \(userType!.rawValue)")
        }
    }
    
    var diner: Diner?
    var truck: TruckRepresentation?
    
    // Mark - Outlets
    
    @IBOutlet weak var truckProfilePicture: UIImageView!
    @IBOutlet weak var userProfilePicture: UIImageView!
    @IBOutlet weak var truckNameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var truckProfileDescription: UITextView!
    @IBOutlet weak var nameProfileDescription: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return diner?.favoriteTrucks.count ?? 0
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "truckCell", for: indexPath)

            cell.textLabel?.text = diner?.favoriteTrucks[indexPath.row].name
            return cell
        }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}


//extension ProfileTableViewController {
//
//    // MARK: - Properties
//    var diner: Diner?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//    }
//
//    // MARK: - Table view data source
////    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
////        return diner?.favoriteTrucks.count ?? 0
////    }
//
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteTruckCell", for: indexPath)
//
//       cell.textLabel?.text = diner?.favoriteTrucks[indexPath.row].name
//        return cell
//    }
//
//
//
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            tableView.deleteRows(at: [indexPath], with: .fade)
////            diner?.favoriteTrucks.remove(at: indexPath.row)
//        }
//    }
//}
