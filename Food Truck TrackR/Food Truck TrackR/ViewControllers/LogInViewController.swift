//
//  LogInViewController.swift
//  Food Truck TrackR
//
//  Created by Juan M Mariscal on 8/19/20.
//  Copyright © 2020 Juan M Mariscal. All rights reserved.
//

import UIKit
import CoreData

class LogInViewController: UIViewController {
    
    //MARK: - IBOutlets and Properties -
    
    var userType: UserType? {
        didSet {
            print("user type has been set to: \(userType!.rawValue)")
        }
    }
    let networkController = NetworkingController()
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //MARK: - IBActions and Methods -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboard()
    }
    
    func setupKeyboard() {
        
        emailTextField.addDoneButtonOnKeyboard()
        passwordTextField.addDoneButtonOnKeyboard()
        
    }
    
    func presentBlankTextFieldsErrorAlert() {
        let alert = UIAlertController(title: "Please enter your login credentials", message: "Please make sure you enter your email and password", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func presentSignInErrorAlert(_ message: String) {
        let alert = UIAlertController(title: "Sign In Error", message: "There was a problem signing you in: \(message)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        guard !emailTextField.text!.isEmpty, !passwordTextField.text!.isEmpty else {
            presentBlankTextFieldsErrorAlert()
            return
        }
        
        let username = emailTextField.text
        let password = passwordTextField.text
        
        if username == "secret" && password == "login" {
            print("Sshhhh come in but keep quiet, This is the secret login")
            dismiss(animated: true, completion: nil)
        }
        
        switch userType {
            
        //logging in for a diner
        case .diner:
            networkController.loginDiner(with: username!, password: password!) { (result) in
                
                do {
                    let dinerRep = try result.get()
                    self.networkController.loggedInDiner = dinerRep
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.presentSignInErrorAlert("Please double check your username and password and try again")
                    }
                    print(error)
                    return
                }
            }
            
        //logging in for an operator
        case .operator:
            networkController.loginOperator(with: username!, password: password!) { (result) in
                
                do {
                    let operatorRep = try result.get()
                    self.networkController.loggedInOperator = operatorRep
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.presentSignInErrorAlert("Please double check your username and password and try again")
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
    
    //Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == .createAccountSegue {
            let createAccountVC = segue.destination as! CreateAccountViewController
            createAccountVC.userType = userType
        }
    }
    
} //End of class

//MARK: - Extensions -

extension UITextField {
    
    @IBInspectable var doneAccessory: Bool {
        
        get {
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        self.resignFirstResponder()
    }
}

