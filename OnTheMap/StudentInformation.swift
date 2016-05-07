//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by KEITH GROUT on 5/7/16.
//  Copyright © 2016 keithwgrout. All rights reserved.
//

import Foundation

struct StudentInformation {

    let firstName: String?
    let lastName: String?
    let latitude: Double?
    let longitude: Double?
    let mapString: String?
    let mediaURL: String?
    let objectID: String?
    let uniqueKey: Int?
    let createdAt: String?
    let updatedAt: String?
    
    init(dictionary: [String:AnyObject]) {
    
        if let firstString = dictionary[ParseClient.JSONResponseKeys.StudentFirstName] as? String {
            firstName = firstString
        }
        if let lastString = dictionary[ParseClient.JSONResponseKeys.StudentLastName] as? String {
            lastName = lastString
        }
        if let latString = dictionary[ParseClient.JSONResponseKeys.StudentLatitude] as? Double {
            latitude = latString
        }
        if let lonString = dictionary[ParseClient.JSONResponseKeys.StudentLongitude] as? Double {
            longitude = lonString
        }
        if let mapStr = dictionary[ParseClient.JSONResponseKeys.StudentMapString] as? String {
            mapString = mapStr
        }
        if let urlString = dictionary[ParseClient.JSONResponseKeys.StudentMediaURL] as? String {
            mediaURL = urlString
        }
        if let obID = dictionary[ParseClient.JSONResponseKeys.StudentObjectID] as? String {
            objectID = obID
        }
        if let studentKey = dictionary[ParseClient.JSONResponseKeys.StudentUniqueKey] as? Int {
            uniqueKey = studentKey
        }
        if let creation = dictionary[ParseClient.JSONResponseKeys.StudentCreatedAt] as? String {
            createdAt = creation
        }
        if let updated = dictionary[ParseClient.JSONResponseKeys.StudentUpdatedAt] as? String {
            updatedAt = updated
        }
    }
    
    
}


