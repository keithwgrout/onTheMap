//
//  ViewController.swift
//  OnTheMap
//
//  Created by KEITH GROUT on 5/2/16.
//  Copyright © 2016 keithwgrout. All rights reserved.
//

import UIKit

let appDel = UIApplication.sharedApplication().delegate as! AppDelegate

class LoginViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var email: String?
    var password: String?

    // MARK: Actions
    
    @IBAction func LoginPressed(sender: UIButton) {
        
        guard validateTextFields(emailTextField, andPasswordTextField: passwordTextField) != false else {
            return
        }
        
        let accountInfo = ["username":email!, "password":password!]
        
        // authenticate with udacity
        // start authentication, and if successful download user data
        UdacityClient().authenticate(accountInfo) { (success, userData, errorString) in
            if success {
                self.initializeUser(userData!)
                ParseClient().getParseData({ (success, errorString) in
                    if success {
                        performUIUpdatesOnMain({
                            self.completeLogin()
                        })
                    } else {
                        performUIUpdatesOnMain({
                            self.downloadFailedAlert()
                        })
                    }
                })
            } else {
                performUIUpdatesOnMain({
                    self.authorizationDidFail(withErrorString: errorString!)
                })
            }
        }
    }
    
    func downloadFailedAlert() {
        let downloadFailureAlert = UIAlertController(title: "Error retrieving data", message: "Student data failed to download", preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        downloadFailureAlert.addAction(action)
        presentViewController(downloadFailureAlert, animated: true, completion: nil)
        
    }
    
    func validateTextFields(emailText: UITextField, andPasswordTextField passwordText: UITextField) -> Bool{
        
        let whitespace = NSCharacterSet.whitespaceCharacterSet()
        
        passwordText.text = passwordText.text?.stringByTrimmingCharactersInSet(whitespace)
        emailText.text = emailText.text?.stringByTrimmingCharactersInSet(whitespace)
        
        if emailText.text == nil || (emailText.text?.isEmpty)!{
            let alert = UIAlertController(title: "Email is required", message: "Please enter the email you used to sign up with Udacity.", preferredStyle: .Alert)
            let action = UIAlertAction(title: "Okay", style: .Default, handler: nil)
            alert.addAction(action)
            presentViewController(alert, animated: true, completion: nil)
            return false
        } else if passwordText.text == nil || (passwordText.text?.isEmpty)! {
            let alert = UIAlertController(title: "Password is required", message: "Please input a password.", preferredStyle: .Alert)
            let action = UIAlertAction(title: "Okay", style: .Default, handler: nil)
            alert.addAction(action)
            presentViewController(alert, animated: true, completion: nil)
            return false
        }
        
        email = emailText.text
        password = passwordText.text
        return true
    }
    
    func authorizationDidFail(withErrorString errorString:String){
        let failureAlert = UIAlertController(title: "Login Unsuccessful", message: "Please try again", preferredStyle: .Alert)

        if errorString == "no internet" {
            failureAlert.title = "No Internet Connection"
            failureAlert.message = "Please reconnect and try again"
        } else if errorString == "invalid credentials" {
            failureAlert.title = "Invalid Username or Password"
            failureAlert.message = "It appears at least one of your credentials is incorrect."
        }
        print("Login not successful")
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        failureAlert.addAction(action)
        presentViewController(failureAlert, animated: true, completion: nil)
    }
    
    func initializeUser(userData:[String:AnyObject])  {
        let userDictionary = userData[ParseClient.AuthResponseKeys.User] as! [String:AnyObject]
        let newUser = User(userDictionary: userDictionary)
        appDel.user = newUser
    }
    
    func completeLogin(){
        print("login complete")
        performSegueWithIdentifier("MTCSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SafariSegue" {
            let webVC = segue.destinationViewController as! SignUpViewController
            webVC.requestURL = NSURL(string: UdacityClient.Constants.SignUPURL)
            print(webVC.requestURL)
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        print("didbeginediting")
        textField.text = ""
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        print("did end editing")
        
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        print("shouldreturn")
        textField.resignFirstResponder()
        return true
    }
}

