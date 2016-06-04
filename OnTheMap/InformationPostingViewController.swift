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
                        self.hideLocationPostingViews()
                        self.stopAndHideIndicator()
                        self.displayMapWithPlacemark(placemark)
                    })
                } else {
                    self.displayFailureAlert(withTitle: "Geocoding Error", andMessage: "Unable to Geocode Location")
                    self.stopAndHideIndicator()
                }
            }
        } else {
            self.displayFailureAlert(withTitle: "Location Error", andMessage: "Unable to Find Location")
            self.stopAndHideIndicator()
        }
    }
    
    @IBAction func postUserData(sender: UIButton) {
        guard studentWebAddress != nil && studentWebAddress?.isEmpty != true else {
            let noLocationAlertVC = UIAlertController(title: "Oops, you forgot to enter a link!", message: "Please enter a link to be associated with your location.", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "Okay", style: .Default, handler: nil)
            noLocationAlertVC.addAction(okAction)
            presentViewController(noLocationAlertVC, animated: true, completion: nil)
            return
        }
        
        ParseClient().postUserData(studentLocation, andWebAddress: studentWebAddress) { (success, errorString) in
            if success {
                ParseClient().getParseData { (success, errorString) in
                    if success {
                        self.dismissViewControllerAnimated(true, completion: nil)
                    } else {
                        self.displayFailureAlert(withTitle: "Error Retrieving Data", andMessage: errorString)
                    }
                }
            } else {
                self.displayFailureAlert(withTitle: "Error Posting Data", andMessage: errorString)
            }
        }
        
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
        hideURLPostingViews()
    }
    
    override func viewDidLoad() {
        studentLocationField.delegate = self
        studentURL.delegate = self
    }
    
    // MARK: Helper Methods
    
    func displayFailureAlert(withTitle title: String?, andMessage message: String?){
        let alert = UIAlertController(title: title!, message: message!, preferredStyle: .Alert)
        let okayAction = UIAlertAction(title: "Okay", style: .Default, handler: nil)
        alert.addAction(okayAction)
        performUIUpdatesOnMain({
            self.presentViewController(alert, animated: true, completion: nil)
        })
    }
    
    func hideURLPostingViews(){
        studentURL.hidden = true
        mapView.hidden =  true
        submitButton.hidden = true
        geoCodeActivityIndicator.hidden = true
    }
    
    func hideLocationPostingViews(){
        // This method is used inside a closure, necessitating the use of "self"
        self.prompt.hidden = true
        self.findButton.hidden = true
        self.studentLocationField.hidden = true
    }
    
    func stopAndHideIndicator(){
        self.geoCodeActivityIndicator.stopAnimating()
        self.geoCodeActivityIndicator.hidden = true
    }
    
    func displayMapWithPlacemark(placemark: MKPlacemark?){
        var user = appDel.user
        user!.location = placemark?.coordinate
        let lat = user?.location?.latitude
        let lon = user?.location?.longitude
        let center = CLLocationCoordinate2D(latitude: lat!, longitude: lon!)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        
        // Add and zoom into annotation
        self.mapView.region = MKCoordinateRegion(center: center, span: span)
        self.mapView.addAnnotation(MKPlacemark(placemark: placemark!))
        
        self.mapView.hidden = false
        self.studentURL.hidden = false
        self.submitButton.hidden = false
    }
}


// UITextFieldDelegate Protocol
extension InformationPostingViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
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


