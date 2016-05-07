//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by KEITH GROUT on 5/2/16.
//  Copyright © 2016 keithwgrout. All rights reserved.
//

import Foundation

class UdacityClient {
    

    // create a session
    // make a request
    // create a task, using request
    // resume task
    
    
    let session = NSURLSession.sharedSession()
    var sessionID: String?
    var userID: String?
    var registered: Bool?
    
    func authenticate(accountInfo: [String:String], completionHandlerForAuth: (success: Bool, errorString: String?) -> Void) {
        print("authenticating")
        // call get sessionID
        // sessionID's like, what up bro, here's what
        // happened, i got this SessionID for u,
        // im all like cool, imma call getUserData
        // and give it to him so he can grab that
        // userData. So i call getUSERData, and he does his
        // thing and he gives me the userData
        // so then im like, shit aight. if all that went good
        // imma just call my completionHandler and be like yo!
        // success!
        getSessionID(accountInfo) { (success, sessionID, errorString) in
            if success {
                self.getUserData(sessionID) {(success, userData, errorString) in
                    if success {
                        completionHandlerForAuth(success: success, errorString: errorString)
                    } else {
                        completionHandlerForAuth(success: success, errorString: errorString)
                    }
                }
            } else {
                completionHandlerForAuth(success: success, errorString: errorString)
            }
        }
    }
    
    func getUserData(sessionID: String?, completionHandlerForUserData: (success: Bool, userData: String?, errorString: String?) -> Void) {
        // use the user id to get public user data
        let userDataUrlString = "https://www.udacity.com/api/users/\(self.userID!)"
        let request = NSURLRequest(URL: NSURL(string: userDataUrlString)!)
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5))
            
            var parsedData: AnyObject?
            
            do {
                parsedData = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
            } catch {
                parsedData = nil
                print("error parsing raw data")
            }
            
            let stringData = String(parsedData)
            
            completionHandlerForUserData(success: true, userData: stringData, errorString: nil)
        }
        
        task.resume()
        
        
    }
    
    func getSessionID(accountInfo: [String:String], completionHandlerForSessionID: (success: Bool, sessionID: String?, errorString: String?) -> Void) {
    
        // pass in completion handler to be called upon success
        let apiString = UdacityClient.Constants.ApiScheme + UdacityClient.Constants.ApiHost + UdacityClient.Methods.apiSession
        
        let user = accountInfo[UdacityClient.ParameterKeys.Username]!
        let password = accountInfo[UdacityClient.ParameterKeys.Password]!
        
        let apiURL = NSURL(string: apiString)
        
        
        let request = NSMutableURLRequest(URL: apiURL!)

        
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"\(UdacityClient.ParameterKeys.Udacity)\":{\"\(UdacityClient.ParameterKeys.Username)\":\"\(user)\",\"\(UdacityClient.ParameterKeys.Password)\":\"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5))
            /* subset response data! */
//            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            
            var parsedData: AnyObject!
            do {
                parsedData = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
            } catch {
                print("data could not be parsed")
            }
            
            if let account = parsedData[JSONResponseKeys.account] as? [String:AnyObject] {
                self.registered = account[JSONResponseKeys.registered]! as? Bool
                self.userID = account["key"] as? String
            }
            
            if let sessionInfo = parsedData[JSONResponseKeys.session]! as? NSDictionary {
                self.sessionID = sessionInfo[JSONResponseKeys.id]! as? String
                completionHandlerForSessionID(success: true, sessionID: self.sessionID, errorString: nil)
            } else {
                completionHandlerForSessionID(success: false, sessionID: nil, errorString: "error parsing JSON")
            }
            
            
            
            
            
            
            
            
        }
        
        task.resume()

        
    }
    
}
