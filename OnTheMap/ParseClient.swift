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
    let studentList = StudentData.sharedInstance
    
    func postUserData(studentLocation: String?, andWebAddress studentWebAddress: String?, handlerForPostUserData:(success:Bool, errorString: String?)-> Void){
        let request = NSMutableURLRequest(URL: NSURL(string: ParseClient.Methods.StudentLocation)!)
        
        request.HTTPMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.HTTPBody = "{\"uniqueKey\": \"\(User.currentUser!.uniqueKey!)\",\"firstName\": \"\(User.currentUser!.firstName!)\",\"lastName\":\"\(User.currentUser!.lastName!)\",\"mapString\": \"\(studentLocation!)\",\"mediaURL\":  \"\(studentWebAddress!)\",\"latitude\":\(User.currentUser!.location!.latitude),\"longitude\":\(User.currentUser!.location!.longitude)}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            guard error == nil else {
                print("error: ", error)
                handlerForPostUserData(success: false, errorString: "Error encountered while posting data.")
                return
            }
            
            guard response != nil else {
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

    
    func getParseData(completionHandlerForParseData: (success: Bool, errorString: String?) -> Void){
        
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
            
            if let studentJSONArray = parsedData!["results"] as? [[String:AnyObject]] {
                let students = Student.studentsFromResults(studentJSONArray)
                self.studentList.students = students
                completionHandlerForParseData(success: true, errorString: nil)
            } else {
                completionHandlerForParseData(success: false, errorString: nil)
            }
            
        }
        task.resume()
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}