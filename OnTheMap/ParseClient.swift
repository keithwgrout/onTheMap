
//  ParseClient.swift
//  OnTheMap
//
//  Created by KEITH GROUT on 5/6/16.
//  Copyright © 2016 keithwgrout. All rights reserved.
//

import Foundation

class ParseClient {
    
    let parseSession = NSURLSession.sharedSession()

    func getParseData(completionHandlerForParseData: (students: [Student], success: Bool, errorString: String) -> Void){
        
        let requestURLString = Methods.StudentLocation
        let requestURL = NSURL(string: requestURLString)
        
        let request = NSMutableURLRequest(URL: requestURL!)
        request.addValue(Constants.ParseAppID, forHTTPHeaderField: Constants.HeaderFieldAppId)
        request.addValue(Constants.RestAPIKey, forHTTPHeaderField: Constants.HeaderFieldAPIKey)
        
        let task = parseSession.dataTaskWithRequest(request) { (data, response, error) in
            
            var parsedData: AnyObject?
            do {
                parsedData = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
            } catch {
                print("error parsing data")
                parsedData = nil
            }
            
            let studentJSONArray = parsedData!["results"] as! [[String:AnyObject]]
            let students = Student.studentsFromResults(studentJSONArray)
            print(students.count)
            completionHandlerForParseData(students: students, success: true, errorString: "all good")
        }
        task.resume()
        
    }
    
    
    func postStudentData(){
        // build student data
        
        // initialize request
//        var request = NSMutableURLRequest(URL: nsurl)
        // build request
        // create task
        // post data
        // get response
        // resume task
    
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}