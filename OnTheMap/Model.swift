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
    //var studentLocations : NSArray?
    var studentLocations : [StudentLocation]?
    struct StudentLocation {
        let createdAt : String // "2015-12-15T08:35:29.521Z";
        let firstName : String // Benjamin;
        let lastName : String  // Johnston;
        let latitude : Double // "52.51888";
        let longitude : Double // "-7.859928";
        let mapString : String // "Ireland ";
        let mediaURL : String // "www.google.com";
        let objectId : String // 1LKX9Px8Jw;
        let uniqueKey : String // u1940027;
        let updatedAt : String // "2015-12-15T08:35:29.521Z";
        init(createdAt: String, firstName : String, lastName: String,
            latitude : Double, longitude : Double, mapString: String, mediaURL: String,objectId : String,
            uniqueKey : String, updatedAt: String)
        {
            self.createdAt = createdAt
            self.firstName = firstName
            self.lastName = lastName
            self.latitude = latitude
            self.longitude = longitude
            self.mapString = mapString
            self.mediaURL = mediaURL
            self.objectId = objectId
            self.uniqueKey = uniqueKey
            self.updatedAt = updatedAt
        }
    }

    let signUpURL = "https://www.google.com/url?q=https://www.udacity.com/account/auth%23!/signin&sa=D&ust=1452592175802000&usg=AFQjCNF4P-G8QbOSHdZPa1TAOB4wnzzDVQ"

    func warningAlertView(parent : UIViewController, messageString : String) -> UIAlertController{
        let alert = UIAlertController(title: "", message: messageString, preferredStyle: .Alert)
        let dismissAction = UIAlertAction(title: "Dismiss",
                                          style: .Cancel,
                                        handler: nil)
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
                let alert = self.warningAlertView(controller,messageString: "Download fails")
                dispatch_async(dispatch_get_main_queue()) {
                    controller.presentViewController(alert, animated: true, completion: nil)
                }

                return
            }
            
            do {
                if let parsedResult = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? NSDictionary,
                    results = parsedResult["results"] as? [[String : AnyObject]]{
                        print("Students location:\(results)")
                        self.studentLocations = [StudentLocation]()
                        for entry in results {
                            let student = Model.StudentLocation(createdAt : entry["createdAt"] as! String,
                                firstName : entry["firstName"] as! String,
                                lastName : entry["lastName"] as! String,
                                latitude : entry["latitude"] as! Double,
                                longitude : entry["longitude"] as! Double,
                                mapString : entry["mapString"] as! String,
                                mediaURL : entry["mediaURL"] as! String,
                                objectId : entry["objectId"] as! String,
                                uniqueKey : entry["uniqueKey"] as! String,
                                updatedAt : entry["updatedAt"] as! String)

                            self.studentLocations!.append(student)
                        }

                        dispatch_async(dispatch_get_main_queue()) {
                            controller.viewWillAppear(true)
                        }
                        
                }
            }
            catch {
                let alert = self.warningAlertView(controller,messageString: "Error parsing JSON data")
                dispatch_async(dispatch_get_main_queue()) {
                    controller.presentViewController(alert, animated: true, completion: nil)
                }

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