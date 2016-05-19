//
//  ViewController.swift
//  OnTheMap
//
//  Created by KEITH GROUT on 5/2/16.
//  Copyright © 2016 keithwgrout. All rights reserved.
//

import UIKit

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
        
        let accountInfo = ["username":user, "password":password]
        
        // start authentication, and if successful download user data
        UdacityClient().authenticate(accountInfo) { (success, errorString) in
                if success {
                    ParseClient().getParseData({ (students, success, errorString) in
                        if success {
                         performUIUpdatesOnMain({ 
                            self.completeLogin(students)
                         })
                        } else {
                            print("could not login successfully")
                        }
                        
                    })
                } else {
                    print("Login not successful")
                }
        }
    }
    
    func completeLogin(students: [Student]){
        print("login complete")
        let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        appDel.students = students
        
        let mapTC = storyboard?.instantiateViewControllerWithIdentifier("MapTabController") as! MapTabController
                
        presentViewController(mapTC, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

