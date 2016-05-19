//
//  ParseConstants.swift
//  OnTheMap
//
//  Created by KEITH GROUT on 5/6/16.
//  Copyright © 2016 keithwgrout. All rights reserved.
//

import Foundation

extension ParseClient {
    
    struct Constants {
        static let ParseAppID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RestAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let HeaderFieldAppId = "X-Parse-Application-Id"
        static let HeaderFieldAPIKey = "X-Parse-REST-API-Key"
    }
    
    struct Methods {
        static let StudentLocation = "https://api.parse.com/1/classes/StudentLocation"
    }
    
    struct Parameters {
        
        // max number of StudentLocation objects to return in the JSON response
        static let limit = 100
        
        // use with limit to paginate thru results
        static let skip = 400
        
        // (String) a comma-separate list of key names that specify the sorted 
        // order of the results
        static let order = ""
    }
    
    struct JSONResponseKeys {
        static let results = "results"
        
        static let StudentFirstName = "firstName"
        static let StudentLastName = "lastName"
        static let StudentLatitude = "latitude"
        static let StudentLongitude = "longitude"
        static let StudentMapString = "mapString"
        static let StudentMediaURL = "mediaURL"
        static let StudentObjectID = "objectID"
        static let StudentUniqueKey = "uniqueKey"
        static let StudentCreatedAt = "createdAt"
        static let StudentUpdatedAt = "updatedAt"
    }

}