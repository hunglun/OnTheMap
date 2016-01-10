//
//  Model.swift
//  OnTheMap
//
//  Created by hunglun on 1/10/16.
//  Copyright © 2016 hunglun. All rights reserved.
//

import Foundation

class Model : NSObject {

    var userId : String!
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> Model {
        
        struct Singleton {
            static var sharedInstance = Model()
        }
        
        return Singleton.sharedInstance
    }

}