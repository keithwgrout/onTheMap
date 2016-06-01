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
    @IBOutlet weak var geoCodeActivityIndicator: UIActivityIndicatorView!
    
    var studentAnnotation: MKPointAnnotation!
    var studentLocation: String?
    var studentWebAddress: String?

    @IBAction func cancelPosting(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func findOnTheMap(sender: UIButton) {
        
        
        geoCodeActivityIndicator.hidden = false
        geoCodeActivityIndicator.startAnimating()
        
        if let location = studentLocation {
            geoForwardLocation(location) {
                (success, errorString, placemark) in
                if success {
                    performUIUpdatesOnMain({
                        self.prompt.hidden = true
                        self.findButton.hidden = true
                        self.studentLocationField.hidden = true
                        self.geoCodeActivityIndicator.stopAnimating()
                        self.geoCodeActivityIndicator.hidden = true
                        
                        appDel.user?.location = placemark?.coordinate
                        var user = appDel.user
                        user!.location = placemark?.coordinate
                        let lat = user?.location?.latitude
                        let lon = user?.location?.longitude
                        let center = CLLocationCoordinate2D(latitude: lat!, longitude: lon!)
                        let span = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
                        self.mapView.region = MKCoordinateRegion(center: center, span: span)
                        
                        self.mapView.addAnnotation(MKPlacemark(placemark: placemark!))
                        
                        self.mapView.hidden = false
                        self.studentURL.hidden = false
                        self.submitButton.hidden = false
                    })
                } else {
                    let geocodeFailAlert = UIAlertController(title: "Something went wrong", message: "Unable to Geocode Location", preferredStyle: .Alert)
                    let okayAction = UIAlertAction(title: "Okay", style: .Default, handler: nil)
                    geocodeFailAlert.addAction(okayAction)
                    performUIUpdatesOnMain({ 
                        self.presentViewController(geocodeFailAlert, animated: true, completion: nil)
                    })
                }
            }
        } else {
            let geocodeAlert = UIAlertController(title: "Something went wrong", message: "Unable to Find Location", preferredStyle: .Alert)
            let okayAction = UIAlertAction(title: "Okay", style: .Default, handler: nil)
            geocodeAlert.addAction(okayAction)
            presentViewController(geocodeAlert, animated: true, completion: nil)
            geoCodeActivityIndicator.stopAnimating()
            geoCodeActivityIndicator.hidden = true
        }
    }
    
    @IBAction func postUserData(sender: UIButton) {
        
        guard studentWebAddress != nil && studentWebAddress != "" && studentWebAddress?.isEmpty != true else {
            let noLocationAlertVC = UIAlertController(title: "Oops, you forgot to enter a link bro!", message: "Please enter a link to be associated with your location.", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "Okay", style: .Default, handler: nil)
            noLocationAlertVC.addAction(okAction)
            presentViewController(noLocationAlertVC, animated: true, completion: nil)
            return
        }
        
        print(studentWebAddress!)
        // make NSurlRequest with api method
        let request = NSMutableURLRequest(URL: NSURL(string: ParseClient.Methods.StudentLocation)!)
        // declare type of request (GET, POST, etc)
        request.HTTPMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.HTTPBody = "{\"uniqueKey\": \"\(appDel.user!.uniqueKey!)\",\"firstName\": \"\(appDel.user!.firstName!)\",\"lastName\":\"\(appDel.user!.lastName!)\",\"mapString\": \"\(studentLocation!)\",\"mediaURL\":  \"\(studentWebAddress!)\",\"latitude\":\(appDel.user!.location!.latitude),\"longitude\":\(appDel.user!.location!.longitude)}".dataUsingEncoding(NSUTF8StringEncoding)
        
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
        geoCodeActivityIndicator.hidden = true
    }
    
    override func viewDidLoad() {
        studentLocationField.delegate = self
        studentURL.delegate = self
    }
    

}

extension InformationPostingViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(textField: UITextField) {
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        print("did end editing")
        
        if textField == studentLocationField {
            if let text = textField.text {
                studentLocation = text
            }
        }
        if textField == studentURL {
            let whitespace = NSCharacterSet.whitespaceCharacterSet()
            if let text = textField.text {
                studentWebAddress = text.stringByTrimmingCharactersInSet(whitespace)
            }
        }
        
        
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


