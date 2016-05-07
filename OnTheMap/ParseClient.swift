//
//  ParseClient.swift
//  OnTheMap
//
//  Created by KEITH GROUT on 5/6/16.
//  Copyright © 2016 keithwgrout. All rights reserved.
//

import Foundation

class ParseClient {
    
    let parseSession = NSURLSession.sharedSession()

    func getParseData(){
        
        let requestURLString = Methods.StudentLocation
        let requestURL = NSURL(string: requestURLString)
        
        let request = NSMutableURLRequest(URL: requestURL!)
        request.addValue(Constants.ParseAppID, forHTTPHeaderField: Constants.HeaderFieldAppId)
        request.addValue(Constants.RestAPIKey, forHTTPHeaderField: Constants.HeaderFieldAPIKey)
        
        let task = parseSession.dataTaskWithRequest(request) { (data, response, error) in
            
            let jsonObject = try! NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
            print(jsonObject)
        }
        task.resume()
        
    }
    
}