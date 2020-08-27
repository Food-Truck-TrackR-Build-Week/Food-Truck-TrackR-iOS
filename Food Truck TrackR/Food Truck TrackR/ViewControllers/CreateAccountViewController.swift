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
    
    @IBAction func createAccountButtonTapped(_ sender: UIButton) {

        guard !firstNameTextField.text!.isEmpty,
            !lastNameTextField.text!.isEmpty,
            !emailTextField.text!.isEmpty,
            !passwordTextField.text!.isEmpty,
            !passwordConfirmationTextField.text!.isEmpty else {
                presentBlankTextFieldsErrorAlert()
                return
        }
        
        guard passwordTextField.text == passwordConfirmationTextField.text else {
            presentPasswordsMismatchErrorAlert()
            return
        }
        
        ///Handle creating user's account
        
        self.dismiss(animated: true, completion: nil)
    }
    
} //End of class
