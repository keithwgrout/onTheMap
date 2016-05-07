//
//  todo.swift
//  OnTheMap
//
//  Created by KEITH GROUT on 5/3/16.
//  Copyright © 2016 keithwgrout. All rights reserved.
//

import Foundation

/*
 
 
 
 Map And Table Tabbed View
 
 
 When the map tab is selected, the view displays a map with pins 
 specifying the last 100 locations posted by students.
 
 
 We need a MapController and a ParseClient as well as a StudentInformation struct which is
 going to be part of our model.
 
 The MapTabController can talk to the ParseClient and will request data from Parse, 
 possibly in ViewWillAppear.
 
 ParseClient will return data from Parse, 
 
 
 *********** Start from below
 
 
 and then we can turn that into a StudentInformation
 struct, which will have an extension that populates an array of Students. 
 
 MapTabController can update the mapView and tab view
 
 We will use that array to populate the map.
 
 
 
 
 
 
 
 
 
 
 The user is able to zoom and scroll the map to any location using 
 standard pinch and drag gestures.
 
 When the user taps a pin, it displays the pin annotation popup, 
 with the student’s name (pulled from their Udacity profile) 
 and the link associated with the student’s pin.
 
 Tapping anywhere within the annotation will launch Safari and 
 direct it to the link associated with the pin.
 
 
 */