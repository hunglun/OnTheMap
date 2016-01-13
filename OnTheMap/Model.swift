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
    var studentLocations : NSArray!
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
                        let navigationController = controller.storyboard!.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
                        if(controller.title == "Login View Controller"){
                            controller.presentViewController(navigationController, animated: true, completion: nil)
                        }else{
                            dispatch_async(dispatch_get_main_queue()) {
                                controller.viewWillAppear(true)
                            }
                        
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