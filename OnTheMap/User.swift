//
//  User.swift
//  OnTheMap
//
//  Created by KEITH GROUT on 5/24/16.
//  Copyright © 2016 keithwgrout. All rights reserved.
//

import Foundation
import CoreLocation

struct User {
    
    var firstName: String?
    var lastName: String?
    var location: CLLocationCoordinate2D?
    var uniqueKey: String?
    
    init(userDictionary:[String:AnyObject]) {
            if let firstString = userDictionary[ParseClient.AuthResponseKeys.UserFirstName] as? String {
                firstName = firstString
            } else {
                firstName = ""
            }
            if let lastString = userDictionary[ParseClient.AuthResponseKeys.UserLastName] as? String {
                lastName = lastString
            } else {
                lastName = ""
            }
            if let studentKey = userDictionary[ParseClient.AuthResponseKeys.UserKey] as? String {
                uniqueKey = studentKey
            } else {
                uniqueKey = "0"
            }
            
            
        }
}