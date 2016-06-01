//
//  MapTabController.swift
//  OnTheMap
//
//  Created by KEITH GROUT on 5/4/16.
//  Copyright © 2016 keithwgrout. All rights reserved.
//

import UIKit

class MapTabController: UITabBarController {
    
    @IBAction func reloadData(sender: UIBarButtonItem) {
        ParseClient().getParseData({ (students, success, errorString) in
            if success {
                print("success")
                appDel.students = students!
                let tableVC = self.storyboard?.instantiateViewControllerWithIdentifier("StudentTableViewController") as! StudentTableViewController
                tableVC.students = students!
                performUIUpdatesOnMain({
                    tableVC.tableView!.reloadData()
                    
                })
            } else {
                print("could not download data successfully")
                let reloadFailedAlert = UIAlertController(title: "Something went wrong", message: "Unable to reload data", preferredStyle: .Alert)
                let okayAction = UIAlertAction(title: "Okay", style: .Default, handler: nil)
                reloadFailedAlert.addAction(okayAction)
                performUIUpdatesOnMain({
                    self.presentViewController(reloadFailedAlert, animated: true, completion: nil)
                })
                
            }
        })
    }
    @IBAction func logOut(sender: UIBarButtonItem) {
        UdacityClient().deleteSession()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func addInformation(sender: UIBarButtonItem) {
        let IPVC = storyboard?.instantiateViewControllerWithIdentifier("InformationPostingViewController") as! InformationPostingViewController
        presentViewController(IPVC, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
    }

}
