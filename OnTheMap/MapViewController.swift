//
//  MapViewController.swift
//  OnTheMap
//
//  Created by KEITH GROUT on 5/7/16.
//  Copyright © 2016 keithwgrout. All rights reserved.
//

import MapKit
import CoreLocation
import UIKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        let center = CLLocationCoordinate2D(latitude: 37, longitude: -98.5795)
        let span = MKCoordinateSpan(latitudeDelta: 20, longitudeDelta: 80)
        mapView.region = MKCoordinateRegion(center: center, span: span)
        mapView.addAnnotations(StudentData.sharedInstance.students!)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        // Do any additional setup after loading the view.
    }
  
}

extension MapViewController: MKMapViewDelegate {

    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        // assign a reuseID
        let reuseID = "pin"
        
        // dequeue a reusable annotation from mapView if possible
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseID) as? MKPinAnnotationView
        
        // if a pinview (annotation) doesn't exist in the queue, create a new one
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        } else {
            // else if an annotation does exist in the queue, we'll make pinViews annotation the current annotation
            pinView!.annotation = annotation

        }
        // return the annotationView
        return pinView
    }

    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            
            let url = NSURL(string: ((view.annotation?.subtitle)!)!)
            var urlString: String
            
            if var url = url {
                urlString = String(url)
                if url.scheme.lowercaseString != "https" && url.scheme.lowercaseString != "http" {
                    urlString = "http://" + urlString
                    url = NSURL(string: urlString)!
                }
                app.openURL(url)
            } else {
                let alert = UIAlertController(title: "Something went wrong", message: "There was no available url to load.", preferredStyle: .Alert)
                let alertAction = UIAlertAction(title: "Okay", style: .Default, handler: nil)
                alert.addAction(alertAction)
                presentViewController(alert, animated: true, completion: nil)
            }
            
            
        }
    }
    
    
    
}
