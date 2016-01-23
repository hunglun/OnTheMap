//
//  Convenience.swift
//  OnTheMap
//
//  Created by hunglun on 1/15/16.
//  Copyright © 2016 hunglun. All rights reserved.
//

import UIKit
import SystemConfiguration

extension Model {

    func httpPutStudentLocation(controller : UIViewController,objectId : String,requestBody: String, errorString: String,
                                submitComplete : () -> Void){
        
        let urlString = "https://api.parse.com/1/classes/StudentLocation/\(objectId)"
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "PUT"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = requestBody.dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                let alert = Model.sharedInstance().warningAlertView(controller,messageString: errorString)
                dispatch_async(dispatch_get_main_queue()) {
                    controller.presentViewController(alert, animated: true, completion: nil)
                }
            }else{
                submitComplete()
            }
            
        }
        task.resume()

    
    }
    
    func httpPostStudentLocation(controller : UIViewController,requestBody : String, errorString : String,
                  submitComplete : ()-> Void){
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        request.HTTPMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = requestBody.dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                let alert = Model.sharedInstance().warningAlertView(controller,messageString: errorString)
                dispatch_async(dispatch_get_main_queue()) {
                    controller.presentViewController(alert, animated: true, completion: nil)
                }
                
            }else{
                submitComplete()
            }
            
        }
        task.resume()


    }
    
    
    func isNetworkAvailable() -> Bool    {
        var flags:SCNetworkReachabilityFlags = .TransientConnection
        let  address: SCNetworkReachabilityRef
        address = SCNetworkReachabilityCreateWithName( nil,"www.apple.com" )!
        let success = SCNetworkReachabilityGetFlags(address, &flags)
        
        let canReach = success && ((flags.rawValue & SCNetworkReachabilityFlags.Reachable.rawValue) != 0)
        
        return canReach;
    }
    
    func authenticate(email: String, password: String,
        loginSuccessHandler: (success: Bool, errorString: String?) -> Void){

            let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
            request.HTTPMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.HTTPBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
            
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request) { data, response, error in
                if error != nil { // Handle error…
                    loginSuccessHandler(success: false,errorString: "Bad Connection")
                    return
                }
                let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
                print(NSString(data: newData, encoding: NSUTF8StringEncoding))
                do {
                    if let parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments) as? NSDictionary,
                        session = parsedResult["account"],
                        id = session["key"] as? String{
                            print(id)
                            Model.sharedInstance().userId = id
                            loginSuccessHandler(success: true,errorString: nil)
                    }
                    else{
                        loginSuccessHandler(success: false,errorString: "Invalid Password or Email")
                    }
                    
                }catch{
                    loginSuccessHandler(success: false,errorString: "Error parsing JSON object")
                    print("Failed to parse JSON data from Udacity Session Request Response")
                }
            }
            task.resume()

        }
    
    func logout(controller: UIViewController){
    
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            controller.dismissViewControllerAnimated(true, completion: nil)
        }
        task.resume()

    }


}
