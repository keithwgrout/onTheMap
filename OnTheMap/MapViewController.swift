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
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var students = [Student]()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        let center = CLLocationCoordinate2D(latitude: 37, longitude: -98.5795)
        let span = MKCoordinateSpan(latitudeDelta: 20, longitudeDelta: 80)
        mapView.region = MKCoordinateRegion(center: center, span: span)
        students = appDelegate.students
        mapView.addAnnotations(students)

    }
    
    @IBAction func logout(sender: UIBarButtonItem) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        // Do any additional setup after loading the view.
    }
  
}

extension MapViewController: MKMapViewDelegate {
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
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
    
    
    // here we can respond to taps
    // it opens the system browser to the url specified in the annotations subtitle
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(NSURL(string: toOpen)!)
            }
        }
    }
    
    
    
}
