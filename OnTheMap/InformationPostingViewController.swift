//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by hunglun on 1/12/16.
//  Copyright © 2016 hunglun. All rights reserved.
//

import UIKit
import CoreLocation

class InformationPostingViewController : UIViewController, UITextFieldDelegate {


    @IBOutlet var locationTextField: UITextField!
    
    override func viewDidLoad() {
        locationTextField.delegate = self
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()

        return true
    }

    @IBAction func findOnTheMapButton(sender: AnyObject) {
        if let location = locationTextField.text as String? ,
            let informationPostingMapViewController = self.storyboard!.instantiateViewControllerWithIdentifier("InformationPostingMapViewController") as? InformationPostingMapViewController {
            
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(location){ (placemarks: [CLPlacemark]?,error : NSError?) in
                if let _ = error {

                    let alert = Model.sharedInstance().warningAlertView(self,messageString: "Geocoding fails")
                    dispatch_async(dispatch_get_main_queue()) {
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                  
                }else {
                    
                    let placemark = placemarks![0] as CLPlacemark
                    if let locationCoordinate = placemark.location?.coordinate {
                        informationPostingMapViewController.locationCoordinate = locationCoordinate

                        informationPostingMapViewController.mapString = location
                        
                        self.presentViewController(informationPostingMapViewController, animated: true, completion: nil)
                    }else{
                        let alert = Model.sharedInstance().warningAlertView(self,messageString: "Location coordinate is nil")
                        dispatch_async(dispatch_get_main_queue()) {
                            self.presentViewController(alert, animated: true, completion: nil)
                        }
                        
                    
                    }
                
                }
            }
        }

    }

}
