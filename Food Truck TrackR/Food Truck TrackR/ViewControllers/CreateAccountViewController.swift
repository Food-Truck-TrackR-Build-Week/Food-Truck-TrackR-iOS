//
//  CreateAccountViewController.swift
//  Food Truck TrackR
//
//  Created by Waseem Idelbi on 8/25/20.
//  Copyright © 2020 Juan M Mariscal. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController {
    
    //MARK: - Properties and IBOutlets -
    
    var userType: UserType? {
        didSet {
            print("user type has been set to: \(userType!.rawValue)")
        }
    }
    let networkController = NetworkingController()
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmationTextField: UITextField!
    
    //MARK: - Methods and IBActions -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboard()
    }
    
    func setupKeyboard() {
        firstNameTextField.addDoneButtonOnKeyboard()
        lastNameTextField.addDoneButtonOnKeyboard()
        emailTextField.addDoneButtonOnKeyboard()
        passwordTextField.addDoneButtonOnKeyboard()
        passwordConfirmationTextField.addDoneButtonOnKeyboard()
    }
    
    func presentBlankTextFieldsErrorAlert() {
        let alert = UIAlertController(title: "Please provide your information", message: "Please be sure to fill out all the fields with your information", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func presentPasswordsMismatchErrorAlert() {
        let alert = UIAlertController(title: "Passwords do not match", message: "Sorry, but it looks like your passwords do not match, please try again", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func presentCreateAccountErrorAlert() {
        let title = "Error"
        let message = "Sorry, but for some reason we were not able to create an account for you. Please try again later"
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    @IBAction func createAccountButtonTapped(_ sender: UIButton) {
        
        guard !emailTextField.text!.isEmpty,
            !passwordTextField.text!.isEmpty,
            !passwordConfirmationTextField.text!.isEmpty else {
                presentBlankTextFieldsErrorAlert()
                return
        }
        
        guard passwordTextField.text == passwordConfirmationTextField.text else {
            presentPasswordsMismatchErrorAlert()
            return
        }
        
        let username = emailTextField.text!
        let password = passwordTextField.text!
        
        switch userType {
            
        //Creates account and logs in for a diner
        case .diner:
            networkController.createDiner(with: username, password: password, email: username, currentLocation: nil) { (result) in
                
                do {
                    let createdDiner = try result.get()
                    self.networkController.loggedInDiner = createdDiner
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.presentCreateAccountErrorAlert()
                    }
                    print(error)
                    return
                }
            }
            
        //Creates account and logs in for an operator
        case .operator:
            networkController.createOperator(with: username, password: password, email: username) { (result) in
                
                do {
                    let createdOperator = try result.get()
                    self.networkController.loggedInOperator = createdOperator
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.presentCreateAccountErrorAlert()
                    }
                    print(error)
                    return
                }
            }
            
        //impossible case, you will never get here!
        case .none:
            print("what the heck, how did you get here?!")
        }
    }
    
} //End of class
