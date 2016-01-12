//
//  TableViewController.swift
//  OnTheMap
//
//  Created by hunglun on 1/10/16.
//  Copyright © 2016 hunglun. All rights reserved.
//

import UIKit

let ParseApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
let RESTAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"

class TabBarController : UITabBarController {

    func pin(){
        //TODO: pin
        print("In Pin")
        let informationPostingViewController = self.storyboard!.instantiateViewControllerWithIdentifier("InformationPostingViewController") as UIViewController!
        presentViewController(informationPostingViewController, animated: true, completion: nil)
        
    }
    
    func refresh() {
        //TODO: refresh
    
    }
    
    func logout(){
        //TODO: logout
    }
    
    override func viewDidLoad() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Refresh", style: .Plain, target: self, action: "refresh")
        navigationItem.leftBarButtonItem  = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: "logout")
        let pinButton = UIBarButtonItem(title: "Pin", style: .Plain, target: self, action: "pin")
        navigationItem.rightBarButtonItems?.append(pinButton)

        print("In Tab Controller")
    }

}



/* 
//Get Udacity User Info
let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/users/\(userid)")!)
let session = NSURLSession.sharedSession()
let task = session.dataTaskWithRequest(request) { data, response, error in
if error != nil { // Handle error...
print(error)
return
}
let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
print(NSString(data: newData, encoding: NSUTF8StringEncoding))
}
task.resume()

*/