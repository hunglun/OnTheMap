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
        print("In Pin")
        let informationPostingViewController = self.storyboard!.instantiateViewControllerWithIdentifier("InformationPostingViewController") as UIViewController!
        presentViewController(informationPostingViewController, animated: true, completion: nil)
        
    }
    
    func refresh() {
        Model.sharedInstance().getStudentLocations(self)

    }
    
    func logout(){
        //TODO: logout
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    
        self.tableView.reloadData()
    }

    func populateNavigationBar() {
            
     
        let pinButton = UIBarButtonItem(image: UIImage(named: "pin"), style: .Plain, target: self, action: "pin")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "refresh")
        navigationItem.leftBarButtonItem  = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: "logout")
        navigationItem.rightBarButtonItems?.append(pinButton)
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateNavigationBar()
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        /* Get cell type */
        let cellReuseIdentifier = "TableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!
        
        /* Set cell defaults */
        if let studentProfile = Model.sharedInstance().studentLocations[indexPath.row] as? NSDictionary,
                firstName = studentProfile["firstName"] as? String,
                lastName = studentProfile["lastName"] as? String {
            
            cell.textLabel!.text = firstName + " " + lastName
            cell.imageView!.image = UIImage(named: "pin")
        }
        return cell

    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let mediaURL = Model.sharedInstance().studentLocations[indexPath.row]["mediaURL"] as? String {
            let app = UIApplication.sharedApplication()
            app.openURL(NSURL(string: mediaURL)!)
            print(mediaURL)
        }
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(Model.sharedInstance().studentLocations.count,100)
    }
}
