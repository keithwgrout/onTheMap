//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by KEITH GROUT on 5/2/16.
//  Copyright © 2016 keithwgrout. All rights reserved.
//


extension UdacityClient {
    
    struct Constants {
        
        // MARK: ApiKey
        static let apiKey = ""
        
        // MARK: URL
        static let ApiScheme = "https://"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = ""
        static let AuthorizationURL = ""
        static let SignUPURL = "https://www.udacity.com/account/auth#!/signup"
    
    }
    
    struct Methods {
        static let apiSession = "/api/session"
    }
    
    struct ParameterKeys {
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
        
    }
    
    struct JSONResponseKeys {
        static let account = "account"
        static let session = "session"
        static let key = "key"
        static let registered = "registered"
        static let id = "id"
        static let error = "error"
        static let status = "status"
    }

}