//
//  ChooseUserTypeViewController.swift
//  Food Truck TrackR
//
//  Created by Waseem Idelbi on 8/25/20.
//  Copyright © 2020 Juan M Mariscal. All rights reserved.
//

import UIKit

enum UserType: String {
    case  `operator`  =  "Operator"
    case   diner      =  "Diner"
}
class ChooseUserTypeViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var operatorButton: UIButton!
    @IBOutlet weak var customerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        operatorButton.layer.cornerRadius = 15
        customerButton.layer.cornerRadius = 15
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let loginVC = segue.destination as! LogInViewController
        
        if segue.identifier ==  "OperatorLoginSegue" {
            loginVC.userType = .operator
            
        } else if segue.identifier == "DinerLoginSegue" {
            loginVC.userType = .diner
            
        }
        
    }
    
} //End of class

extension ChooseUserTypeViewController: UIAdaptivePresentationControllerDelegate {
    
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        let alert = UIAlertController(title: "Please sign in or create an account", message: "In order to use this app, you must either create an account, or sign in to an existing one", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        print("some random stuff")
    }
    
}
