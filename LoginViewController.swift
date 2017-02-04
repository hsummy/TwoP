//
//  LoginViewController.swift
//  TwoP
//
//  Created by HSummy on 1/23/17.
//  Copyright © 2017 HSummy. All rights reserved.
//

import UIKit
import CoreData
import Foundation


//HNS - per David Johnson, created for any TextField in entire app to check if empty and will not crash.
extension UITextField {
    var unwrappedText: String {
        return self.text ?? ""
    }
}

extension UIViewController
{
    //MARK: Alert Message - login and password http://swiftdeveloperblog.com/email-address-validation-in-swift/ and David Johnson to create Alert Messages for user errors in all view controllers.
    
    func displayAlert(withTitle title: String = "Alert", andMessage message: String = "", OKhandler:(() -> Void)? = nil) {
        let style: UIAlertControllerStyle = (UIDevice.current.userInterfaceIdiom == .pad ? .alert : .actionSheet)
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        let OKAction = UIAlertAction(title: "OK", style: .default) { _ in
            OKhandler?()
        }
        
        alert.addAction(OKAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}

class LoginViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var coreEmailTextField: UITextField!
    @IBOutlet weak var corePasswordTextField: UITextField!
    
    //HNS - moved validation Business logic to different class, for cleaner VC code.
    let aLoginValidator = LoginValidator()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        coreEmailTextField.delegate = self
        corePasswordTextField.delegate = self
        //CoreDataManager.StoreObject()
        //CoreDataManager.FetchObject()
    }

    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
    
       // userSignedIn()
        
    }
   
    

//MARK: Email - validate email function http://stackoverflow.com/questions/26180888/what-are-best-practices-for-validating-email-addresses-in-swift and http://swiftdeveloperblog.com/email-address-validation-in-swift/
   
    

    
//MARK: Email and Password - validate each one when Return is tapped
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if textField == coreEmailTextField
        {
            return validateEmailTextField()
        }
        if textField == corePasswordTextField
        {
            let rc = validatePasswordTextField()
            signInButtonTapped(nil)
            return rc
        
        }
        return true
    }
    
    func validateTextFields() -> Bool
    {
        return validateEmailTextField() && validatePasswordTextField()
    }
    
    func validatePasswordTextField() -> Bool
    {
        let aValidPassword = aLoginValidator.validatePassword(passwordString: corePasswordTextField.unwrappedText)
        if aValidPassword
        {
            print("Password is valid")
            corePasswordTextField.resignFirstResponder()
        }
        else
        {
            displayAlert(withTitle: "Error", andMessage: "Password is invalid", OKhandler: {
                //HNS - when user pressed OK on Alert Controller, it will wipe it clean.
                self.corePasswordTextField.text = ""
            })
        }
        
        return aValidPassword
    }
    
    func validateEmailTextField() -> Bool
    {
        let aValidEmail = aLoginValidator.validateEmail(emailString: coreEmailTextField.unwrappedText)
        if aValidEmail
        {
            coreEmailTextField.resignFirstResponder()
        }
        else
        {
            displayAlert(withTitle: "Error", andMessage: "Email is invalid")
        }
        
        return aValidEmail
    }
    
//MARK: Alert Message - login and password http://swiftdeveloperblog.com/email-address-validation-in-swift/
    
    
//MARK: Private Function - is user signed in
    
    
    fileprivate func userSignedIn()
    {
        AppState.sharedInstance.signedIn = true
        //AppState.sharedInstance.displayName = user.displayName ?? user.email

        dismiss(animated: true, completion: nil)
    }

//MARK: IBAction - Signin validation, storage, and segue
    @IBAction func signInButtonTapped(_ sender: UIButton?)
    {
        if validateTextFields()
        {
            //HNS - storing username and password in CoreData when Sign In button is tapped.
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedObjectContext = appDelegate.persistentContainer.viewContext
            // let newUser = NSEntityDescription.insertNewObject(forEntityName: "User", into:managedObjectContext) as! User
            
            do
            {
                try managedObjectContext.save()
                print ("User's email and password saved")
            }
            catch
            {
                fatalError("Failed to save user information:\(error)")
            }
        userSignedIn()
        }
    }

    
    
}//end of class LoginViewController
