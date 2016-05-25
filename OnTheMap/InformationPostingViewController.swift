//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by KEITH GROUT on 5/23/16.
//  Copyright © 2016 keithwgrout. All rights reserved.
//

import UIKit
import CoreLocation
import AddressBookUI
import MapKit

class InformationPostingViewController: UIViewController {
    
    @IBOutlet weak var studentURL: UITextField!
    @IBOutlet weak var studentLocationField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var prompt: UILabel!
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    var studentAnnotation: MKPointAnnotation!
    
    var studentLocation = ""
    var studentWebAddress = ""

    @IBAction func findLocation(sender: UIButton) {
        
        geoForwardLocation(studentLocation) {
            (success, errorString, placemark) in
            if success {
                performUIUpdatesOnMain({
                    self.prompt.hidden = true
                    self.findButton.hidden = true
                    self.studentLocationField.hidden = true
                    
                    appDel.user?.location = placemark?.coordinate
                    self.mapView.addAnnotation(MKPlacemark(placemark: placemark!))
                    
                    self.mapView.hidden = false
                    self.studentURL.hidden = false
                    self.submitButton.hidden = false
                })
            }
        }
    }
    
    @IBAction func postUserData(sender: UIButton) {
        
        // make NSurlRequest with api method
        let request = NSMutableURLRequest(URL: NSURL(string: ParseClient.Methods.StudentLocation)!)
        // declare type of request (GET, POST, etc)
        request.HTTPMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        print(appDel.user!.uniqueKey!, appDel.user!.firstName!,appDel.user!.lastName!,studentLocation,studentWebAddress,appDel.user!.location!.latitude,appDel.user!.location!.longitude)
        
        request.HTTPBody = "{\"uniqueKey\": \"\(appDel.user!.uniqueKey!)\",\"firstName\": \"\(appDel.user!.firstName!)\",\"lastName\":\"\(appDel.user!.lastName!)\",\"mapString\": \"\(studentLocation)\",\"mediaURL\":  \"\(studentWebAddress)\",\"latitude\":\(appDel.user!.location!.latitude),\"longitude\":\(appDel.user!.location!.longitude)}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            guard error == nil else{
                print(error)
                return
            }
            
            var parsedData: AnyObject?
            
            do {
                parsedData = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)

            } catch {
                print("Data could not be parsed into JSON")
            }
            print(parsedData)
            
            
        }
        task.resume()
        
    }
    
    func geoForwardLocation(location: String, completionHandlerForGeoForwardLocation: (success: Bool, errorString: String?, placemark: MKPlacemark?)->Void) {
    
        CLGeocoder().geocodeAddressString(location, completionHandler: {(placemarks, error) in
            
            guard error == nil else {
                print(error)
                completionHandlerForGeoForwardLocation(success: false, errorString: "error", placemark: nil)
                return
            }
            
            if placemarks?.count > 0 {
                let placemark = placemarks?.first
                let mkPlace = MKPlacemark(placemark: placemark!)
                completionHandlerForGeoForwardLocation(success: true, errorString: nil, placemark: mkPlace )
            }
            
        })
    
    }
    
    override func viewWillAppear(animated: Bool) {
        studentURL.hidden = true
        mapView.hidden =  true
        submitButton.hidden = true
    }
    
    override func viewDidLoad() {
        studentLocationField.delegate = self
        studentURL.delegate = self
        studentURL.text = "www.ebay.com"
        studentWebAddress = studentURL.text!
    }
    

}

extension InformationPostingViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(textField: UITextField) {
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        if textField == studentLocationField {
            if let text = textField.text {
                studentLocation = text
            }
        }
        if textField == studentURL {
            if let text = textField.text {
                studentWebAddress = text
            }
        }
        
        
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


