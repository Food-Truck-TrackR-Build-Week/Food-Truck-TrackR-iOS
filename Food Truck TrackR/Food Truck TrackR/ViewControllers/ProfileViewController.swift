//
//  ProfileViewController.swift
//  Food Truck TrackR
//
//  Created by Gladymir Philippe on 8/21/20.
//  Copyright © 2020 Juan M Mariscal. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var usernameLabel: UILabel!

    // MARK: - Properties
    var diner: DinerRepresentation?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }

    private func updateViews() {
        usernameLabel.text = diner?.username
    }
}
