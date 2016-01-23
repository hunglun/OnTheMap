//
//  TableViewController.swift
//  OnTheMap
//
//  Created by hunglun on 1/10/16.
//  Copyright © 2016 hunglun. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    func pin(){

        let informationPostingViewController = self.storyboard!.instantiateViewControllerWithIdentifier("InformationPostingViewController") as UIViewController!
        presentViewController(informationPostingViewController, animated: true, completion: nil)

    }
    
    func refresh() {
        Model.sharedInstance().getStudentLocations(self){
            dispatch_async(dispatch_get_main_queue()) {
                self.viewWillAppear(true)
            }
        }
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)        

        self.tableView.reloadData()
        
    }
    
    func logout () {
        Model.sharedInstance().logout(self)
    }
    
    func populateNavigationBar() {
            
     
        let pinButton = UIBarButtonItem(image: UIImage(named: "pin"), style: .Plain, target: self, action: "pin")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "refresh")
        navigationItem.leftBarButtonItem  = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: "logout")
        navigationItem.rightBarButtonItems?.append(pinButton)
        
        navigationItem.title = "On The Map"

    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateNavigationBar()
        Model.sharedInstance().getStudentLocations(self){
            dispatch_async(dispatch_get_main_queue()) {
                self.viewWillAppear(true)
            }
        }

    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        /* Get cell type */
        let cellReuseIdentifier = "TableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!
        
        /* Set cell defaults */
        if let locations = Model.sharedInstance().studentLocations {
            let studentProfile = locations[indexPath.row]
            cell.textLabel!.text = studentProfile.firstName + " " + studentProfile.lastName
            cell.detailTextLabel!.text = studentProfile.mediaURL
            cell.imageView!.image = UIImage(named: "pin")
        }
        return cell

    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let locations = Model.sharedInstance().studentLocations {
            let mediaURL = locations[indexPath.row].mediaURL
            
            let app = UIApplication.sharedApplication()

            if app.openURL(NSURL(string: mediaURL)!) == false{
                let alert = Model.sharedInstance().warningAlertView(self, messageString: "Invalid URL")
                self.presentViewController(alert, animated: true, completion: nil)
            }

        }
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let locations = Model.sharedInstance().studentLocations ?? []
        return max(locations.count,100)
    }
}
