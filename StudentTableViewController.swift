//
//  StudentetTableViewController.swift
//  OnTheMap
//
//  Created by KEITH GROUT on 5/17/16.
//  Copyright © 2016 keithwgrout. All rights reserved.
//

import UIKit

class StudentTableViewController: UITableViewController {
    
   
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var students = [Student]()

    override func viewDidLoad() {
        super.viewDidLoad()
        students = appDelegate.students
    }

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return students.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StudentCell", forIndexPath: indexPath)

        // Configure the cell...
        let student = students[indexPath.row]
        cell.textLabel?.text = "\(student.firstName!) \(student.lastName!)"
        cell.detailTextLabel?.text = student.mediaURL!
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let student = students[indexPath.row]
        
        let app = UIApplication.sharedApplication()
        app.openURL(NSURL(string: student.subtitle!)!)
        
        
    }

}
