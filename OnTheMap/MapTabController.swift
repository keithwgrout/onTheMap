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
        ParseClient().getParseData({ (success, errorString) in
            if success {
                self.refresh()
            } else {
                self.reloadFailureAlert()
            }
        })
    }
    
    func refresh(){
        let tabs = self.viewControllers
        let tableVC = tabs![1] as! StudentTableViewController
        
        tableVC.students = appDel.students
        tableVC.students.sortInPlace({$0.updatedAt! > $1.updatedAt!})
        performUIUpdatesOnMain({
            tableVC.tableView!.reloadData()
        })
    }
    
    func reloadFailureAlert(){
        let reloadFailedAlert = UIAlertController(title: "Something went wrong", message: "Unable to reload data", preferredStyle: .Alert)
        let okayAction = UIAlertAction(title: "Okay", style: .Default, handler: nil)
        reloadFailedAlert.addAction(okayAction)
        performUIUpdatesOnMain({
            self.presentViewController(reloadFailedAlert, animated: true, completion: nil)
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
    }

}
