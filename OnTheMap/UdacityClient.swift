//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by KEITH GROUT on 5/2/16.
//  Copyright © 2016 keithwgrout. All rights reserved.
//

import Foundation

class UdacityClient {
    
    let session = NSURLSession.sharedSession()
    var sessionID: String?
    var userID: String?
    var registered: Bool?
    
    func authenticate(accountInfo: [String:String], completionHandlerForAuth: (success: Bool, userData:[String:AnyObject]?, errorString: String?) -> Void) {
        print("authenticating")
        getSessionID(accountInfo) { (success, sessionID, errorString) in
            if success {
                print("success")
                self.getUserData(sessionID) {(success, userData, errorString) in
                    if success {
                        completionHandlerForAuth(success: success, userData: userData, errorString: errorString)
                    } else {
                        completionHandlerForAuth(success: success, userData: nil, errorString: errorString)
                    }
                }
            } else {
                print("failed")
                completionHandlerForAuth(success: success, userData: nil, errorString: errorString)
            }
        }
    }
    
    func deleteSession() {
        
        let url = Constants.ApiScheme+Constants.ApiHost+Methods.apiSession
        let request = NSMutableURLRequest(URL: NSURL(string:url)!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" {
                xsrfCookie = cookie
            }
        }
        
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF_TOKEN")
        }
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            guard error == nil else {
                print(error)
                return
            }
            //print(response, data)
            let newData = data?.subdataWithRange(NSMakeRange(5, data!.length - 5))
            print(NSString(data: newData!, encoding: NSUTF8StringEncoding))
            print("Logged Out")
        }
        
        task.resume()
    }
    
    func getUserData(sessionID: String?, completionHandlerForUserData: (success: Bool, userData: [String:AnyObject]?, errorString: String?) -> Void) {
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
            
            let arrayUserData = parsedData! as! [String:AnyObject]
            
            completionHandlerForUserData(success: true, userData: arrayUserData, errorString: nil)
        }
        
        task.resume()
        
        
    }
    
    func getSessionID(accountInfo: [String:String], completionHandlerForSessionID: (success: Bool, sessionID: String?, errorString: String?) -> Void) {
    
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
            
            
            guard response != nil else {
                print("no response")
                if let error = error {
                    if error.code == -1009 {
                        print("Internet appears to be offline")
                    }
                }
                completionHandlerForSessionID(success: false, sessionID: nil, errorString: "no internet")
                return
            }
            guard data != nil else {
                print(data, response, error)
                return
            }
            guard error == nil else {
                print(data, response, error)
                return
            }
            
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5))
            
            var parsedData: AnyObject!
            do {
                parsedData = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
            } catch {
                print("data could not be parsed")
            }
            
            guard parsedData[UdacityClient.JSONResponseKeys.error]! == nil else {
                if parsedData[UdacityClient.JSONResponseKeys.status] as! Int == 403 {
                    print("invalid credentials")
                    completionHandlerForSessionID(success: false, sessionID: nil, errorString: "invalid credentials")
                } else {
                    completionHandlerForSessionID(success: false, sessionID: nil, errorString: "unknown response error")
                }
                return
            }
            
            if let account = parsedData[JSONResponseKeys.account] as? [String:AnyObject] {
                self.registered = account[JSONResponseKeys.registered]! as? Bool
                self.userID = account["key"] as? String
            } else {
                print("account not found")
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
