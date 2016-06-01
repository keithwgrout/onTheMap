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

    // MARK: Actions
    
    @IBAction func LoginPressed(sender: UIButton) {
        
        // authenticate with udacity
        // get username and password
        guard let user = emailTextField.text else {
            print("invalid username")
            return
        }
        guard let password = passwordTextField.text else {
            print("invalid password")
            return
        }
        
        // verify username and password fields are not empty
        
        let accountInfo = ["username":user, "password":password]
        
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
                        print("could not download data successfully")
                        performUIUpdatesOnMain({
                            self.downloadFailed()
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
    
    func downloadFailed() {
        let downloadFailureAlert = UIAlertController(title: "Error retrieving data", message: "Student data failed to download", preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        downloadFailureAlert.addAction(action)
        presentViewController(downloadFailureAlert, animated: true, completion: nil)
        
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
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

