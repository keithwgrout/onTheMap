//
//  StudentetTableViewController.swift
//  OnTheMap
//
//  Created by KEITH GROUT on 5/17/16.
//  Copyright © 2016 keithwgrout. All rights reserved.
//

import UIKit

class StudentTableViewController: UITableViewController {
    
   
   
    var students = [Student]()

    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        super.viewDidLoad()
        tableView.reloadData()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        print("called")
        students = appDel.students
        students.sortInPlace({$0.updatedAt! > $1.updatedAt!})
        tableView.reloadData()
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
        
        var url = NSURL(string: student.subtitle!)
        var urlString: String
        
        if let url = url {
            urlString = String(url)
        } else {
            url = NSURL(string: "apple.com")
            urlString = "apple"
        }
        
        if url!.scheme.lowercaseString != "https" && url!.scheme.lowercaseString != "http" {
            urlString = "http://" + urlString
            url = NSURL(string: urlString)
        }
        app.openURL(url!)
    }

}
