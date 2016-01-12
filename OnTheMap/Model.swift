//
//  Model.swift
//  OnTheMap
//
//  Created by hunglun on 1/10/16.
//  Copyright © 2016 hunglun. All rights reserved.
//

import Foundation

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
    
    class func sharedInstance() -> Model {
        
        struct Singleton {
            static var sharedInstance = Model()
        }
        
        return Singleton.sharedInstance
    }

}