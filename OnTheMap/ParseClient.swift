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
    
    
    
    func postUserData(studentLocation: String?, andWebAddress studentWebAddress: String?, handlerForPostUserData:(success:Bool, errorString: String?)-> Void){
        // make NSurlRequest with api method
        let request = NSMutableURLRequest(URL: NSURL(string: ParseClient.Methods.StudentLocation)!)
        // declare type of request (GET, POST, etc)
        
        request.HTTPMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.HTTPBody = "{\"uniqueKey\": \"\(appDel.user!.uniqueKey!)\",\"firstName\": \"\(appDel.user!.firstName!)\",\"lastName\":\"\(appDel.user!.lastName!)\",\"mapString\": \"\(studentLocation!)\",\"mediaURL\":  \"\(studentWebAddress!)\",\"latitude\":\(appDel.user!.location!.latitude),\"longitude\":\(appDel.user!.location!.longitude)}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            guard error == nil else {
                print(error)
                handlerForPostUserData(success: false, errorString: "Error encountered while posting data.")
                return
            }
            
            guard response == nil else {
                handlerForPostUserData(success: false, errorString: "No response from server.")
                return
            }
            
            var parsedData: AnyObject?
            
            do {
                parsedData = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                handlerForPostUserData(success: true, errorString: nil)
                
            } catch {
                print("Data could not be parsed into JSON")
            }
            print(parsedData)
        }
        task.resume()

    }

    
    func getParseData(completionHandlerForParseData: (success: Bool, errorString: String) -> Void){
        
        let requestURLString = Methods.StudentLocation
        let requestURL = NSURL(string: requestURLString)
        
        let request = NSMutableURLRequest(URL: requestURL!)
        request.addValue(Constants.ParseAppID, forHTTPHeaderField: Constants.HeaderFieldAppId)
        request.addValue(Constants.RestAPIKey, forHTTPHeaderField: Constants.HeaderFieldAPIKey)
        
        let task = parseSession.dataTaskWithRequest(request) { (data, response, error) in
            
            
            
            guard data != nil else {
                print("no data was returned")
                completionHandlerForParseData(success: false, errorString: (error?.description)!)
                return
            }
            guard response != nil else {
                completionHandlerForParseData(success: false, errorString: (error?.description)!)
                return
            }
            
            guard error == nil else {
                completionHandlerForParseData(success: false, errorString: (error?.description)!)
                return
            }
            
            var parsedData: AnyObject?
            do {
                parsedData = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
            } catch {
                print("error parsing data")
                parsedData = nil
            }
            
            let studentJSONArray = parsedData!["results"] as! [[String:AnyObject]]
            let students = Student.studentsFromResults(studentJSONArray)
            appDel.students = students
            print(students.count)
            completionHandlerForParseData(success: true, errorString: "all good")
        }
        task.resume()
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}