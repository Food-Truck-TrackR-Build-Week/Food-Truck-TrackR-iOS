//
//  ProfileTableViewController.swift
//  Food Truck TrackR
//
//  Created by Elizabeth Thomas on 8/27/20.
//  Copyright © 2020 Juan M Mariscal. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {

    // MARK: - Properties
    var diner: DinerRepresentation?

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diner?.favoriteTrucks?.count ?? 0
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteTruckCell", for: indexPath)

        cell.textLabel?.text = diner?.favoriteTrucks?[indexPath.row].name
        return cell
    }



    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.deleteRows(at: [indexPath], with: .fade)
            diner?.favoriteTrucks?.remove(at: indexPath.row)
        }
    }
}
