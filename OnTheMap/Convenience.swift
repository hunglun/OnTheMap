//
//  Convenience.swift
//  OnTheMap
//
//  Created by hunglun on 1/15/16.
//  Copyright © 2016 hunglun. All rights reserved.
//

import UIKit


extension Model {
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
    
    


}
