//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by KEITH GROUT on 5/23/16.
//  Copyright © 2016 keithwgrout. All rights reserved.
//

import UIKit

class InformationPostingViewController: UIViewController {
    
    @IBOutlet weak var studentLocationField: UITextField!
    var studentLocation = ""

    @IBAction func findLocation(sender: UIButton) {
        
    }
    
    override func viewDidLoad() {
        studentLocationField.delegate = self
    }
    

}

extension InformationPostingViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(textField: UITextField) {
        print("BeganEditing")
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if let text = textField.text {
            studentLocation = text
        }
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


