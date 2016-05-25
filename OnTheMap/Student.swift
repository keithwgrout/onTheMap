//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by KEITH GROUT on 5/7/16.
//  Copyright © 2016 keithwgrout. All rights reserved.
//

import Foundation
import MapKit

class Student: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    

    var firstName: String?
    var lastName: String?
    var latitude: Double?
    var longitude: Double?
    var mapString: String?
    var mediaURL: String?
    var objectID: String?
    var uniqueKey: Int?
    var createdAt: String?
    var updatedAt: String?
    
    
    init(dictionary: [String:AnyObject]) {
    
        if let firstString = dictionary[ParseClient.JSONResponseKeys.StudentFirstName] as? String {
            firstName = firstString
        } else {
            firstName = ""
        }
        if let lastString = dictionary[ParseClient.JSONResponseKeys.StudentLastName] as? String {
            lastName = lastString
        } else {
            lastName = ""
        }
        if let latString = dictionary[ParseClient.JSONResponseKeys.StudentLatitude] as? Double {
            latitude = latString
        } else {
            latitude = 0
        }
        if let lonString = dictionary[ParseClient.JSONResponseKeys.StudentLongitude] as? Double {
            longitude = lonString
        }else {
            longitude = 0
        }
        if let mapStr = dictionary[ParseClient.JSONResponseKeys.StudentMapString] as? String {
            mapString = mapStr
        }else {
            mapString = ""
        }
        if let urlString = dictionary[ParseClient.JSONResponseKeys.StudentMediaURL] as? String {
            mediaURL = urlString
        }else {
            mediaURL = ""
        }
        if let obID = dictionary[ParseClient.JSONResponseKeys.StudentObjectID] as? String {
            objectID = obID
        }else {
            objectID = ""
        }
        if let studentKey = dictionary[ParseClient.JSONResponseKeys.StudentUniqueKey] as? Int {
            uniqueKey = studentKey
        }else {
            uniqueKey = 0
        }
        if let creation = dictionary[ParseClient.JSONResponseKeys.StudentCreatedAt] as? String {
            createdAt = creation
        }else {
            createdAt = ""
        }
        if let updated = dictionary[ParseClient.JSONResponseKeys.StudentUpdatedAt] as? String {
            updatedAt = updated
        }else {
            updatedAt = ""
        }
        
        coordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        title = "\(firstName!) \(lastName!) "
        subtitle = mediaURL!
        
    }
    
    static func studentsFromResults(studentsArray: [[String:AnyObject]]) -> [Student]{
    
        var students = [Student]()
        
        for studentDictionary in studentsArray {
            students.append(Student(dictionary: studentDictionary))
        }
        
        return students
    }
    
    
    
    
}


