//
//  TableViewController.swift
//  OnTheMap
//
//  Created by hunglun on 1/10/16.
//  Copyright © 2016 hunglun. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //TODO: add imageView
        /* Get cell type */
        let cellReuseIdentifier = "TableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!
        
        /* Set cell defaults */
        if let studentProfile = Model.sharedInstance().studentLocations[indexPath.row] as? NSDictionary,
                firstName = studentProfile["firstName"] as? String,
                lastName = studentProfile["lastName"] as? String {
            
            cell.textLabel!.text = firstName + " " + lastName
        
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
