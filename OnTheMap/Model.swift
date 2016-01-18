//
//  Model.swift
//  OnTheMap
//
//  Created by hunglun on 1/10/16.
//  Copyright © 2016 hunglun. All rights reserved.
//

import Foundation
import UIKit
class Model : NSObject {
    var firstName : String!
    var lastName : String!
    var userId : String!
    var studentLocations : NSArray?
    /* Student Location
    {
    createdAt = "2015-12-15T08:35:29.521Z";
    firstName = Benjamin;
    lastName = Johnston;
    latitude = "52.51888";
    longitude = "-7.859928";
    mapString = "Ireland ";
    mediaURL = "www.google.com";
    objectId = 1LKX9Px8Jw;
    uniqueKey = u1940027;
    updatedAt = "2015-12-15T08:35:29.521Z";
    }

    */
    let signUpURL = "https://www.google.com/url?q=https://www.udacity.com/account/auth%23!/signin&sa=D&ust=1452592175802000&usg=AFQjCNF4P-G8QbOSHdZPa1TAOB4wnzzDVQ"

    func warningAlertView(parent : UIViewController, messageString : String) -> UIAlertController{
        let alert = UIAlertController(title: "", message: messageString, preferredStyle: .Alert)
        let dismissAction = UIAlertAction(title: "Dismiss",
                                          style: .Cancel,
                                        handler: {(alert: UIAlertAction!) in
                                                  parent.dismissViewControllerAnimated(true, completion: nil)
                                            })
        alert.addAction(dismissAction)
        return alert
    }
    // MARK: Shared Instance
    func getStudentLocations(controller : UIViewController) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            
            do {
                if let parsedResult = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? NSDictionary,
                    results = parsedResult["results"] as? NSArray {
                        print("Students location:\(results)")
                        self.studentLocations = results
                        dispatch_async(dispatch_get_main_queue()) {
                            controller.viewWillAppear(true)
                        }
                        
                }
            }
            catch {
                
            }
            
        }
        task.resume()
        
    }

    class func sharedInstance() -> Model {
        
        struct Singleton {
            static var sharedInstance = Model()
        }
        
        return Singleton.sharedInstance
    }

}