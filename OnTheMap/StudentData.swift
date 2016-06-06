//
//  StudentData.swift
//  OnTheMap
//
//  Created by KEITH GROUT on 6/6/16.
//  Copyright © 2016 keithwgrout. All rights reserved.
//

import Foundation

class StudentData {
    
    static let sharedInstance = StudentData()
    private init() {}
    
    var students: [Student]?
}

/*
 
 The array of structs should not be stored anywhere near the view controllers or the app delegate
 (which could be regarded as a part of the controller layer).
 To meet specification, create another model (singleton) class (For example named StudentData ) 
 and save the array of structs as a static variable.
 
 */