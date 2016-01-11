//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by hunglun on 1/12/16.
//  Copyright © 2016 hunglun. All rights reserved.
//

import UIKit
import CoreLocation

class InformationPostingViewController : UIViewController {


    @IBOutlet var locationTextField: UITextField!
    
    @IBAction func findOnTheMapButton(sender: AnyObject) {
        if let location = locationTextField.text as String? ,
            let informationPostingMapViewController = self.storyboard!.instantiateViewControllerWithIdentifier("InformationPostingMapViewController") as? InformationPostingMapViewController {
            
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(location){ (placemarks: [CLPlacemark]?,error : NSError?) in
                if let error = error {
                    print(error)
                    //TODO: Alert Controller to warn about geocode failure
                    print("Present Alert Box")
                  
                }else {
                    
                    let placemark = placemarks![0] as CLPlacemark
                    if let locationCoordinate = placemark.location?.coordinate {
                        informationPostingMapViewController.locationCoordinate = locationCoordinate
                        self.presentViewController(informationPostingMapViewController, animated: true, completion: nil)
                    }else{
                        //TODO : Alert box
                        print("location coordinate is nil")
                    
                    }
                
                }
            }
        }

    }

}
