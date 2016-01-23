//
//  StudentLocationsMapViewController.swift
//  OnTheMap
//
//  Created by hunglun on 1/12/16.
//  Copyright © 2016 hunglun. All rights reserved.
//

import UIKit
import MapKit

class  StudentLocationsMapViewController: UIViewController,MKMapViewDelegate{

    @IBOutlet weak var mapView: MKMapView!
    
    func pin(){

        let informationPostingViewController = self.storyboard!.instantiateViewControllerWithIdentifier("InformationPostingViewController") as UIViewController!
        presentViewController(informationPostingViewController, animated: true, completion: nil)

    }
    
    func refresh() {

        Model.sharedInstance().getStudentLocations(self){
            dispatch_async(dispatch_get_main_queue()) {
                self.viewWillAppear(true)
            }
        }
       
    }
    
    func logout () {
        Model.sharedInstance().logout(self)

    }

    
    
    func populateNavigationBar() {

        let pinButton = UIBarButtonItem(image: UIImage(named: "pin"), style: .Plain, target: self, action: "pin")

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "refresh")
        navigationItem.leftBarButtonItem  = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: "logout")
        navigationItem.rightBarButtonItems?.append(pinButton)
        
        navigationItem.title = "On The Map"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateNavigationBar()
        Model.sharedInstance().getStudentLocations(self){
            dispatch_async(dispatch_get_main_queue()) {
                self.viewWillAppear(true)
            }
        }
        

    }
    
    override func viewWillAppear(animated: Bool) {


        super.viewWillAppear(animated)
        self.mapView.removeAnnotations(self.mapView.annotations)
        let locations = Model.sharedInstance().studentLocations
        
        // We will create an MKPointAnnotation for each student in "locations". The
        // point annotations will be stored in this array, and then provided to the map view.
        var annotations = [MKPointAnnotation]()
        
        // The "locations" array is loaded with the sample data below. We are using the dictionaries
        // to create map annotations. This would be more stylish if the dictionaries were being
        // used to create custom structs. Perhaps StudentLocation structs.
        if let locations = locations where locations.count != 0 {
            let latestUpdatedProfile = locations[0]
            let lat = CLLocationDegrees(latestUpdatedProfile.latitude)
            let long = CLLocationDegrees(latestUpdatedProfile.longitude )
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)

            self.mapView.centerCoordinate = coordinate
        }
        

        for student in locations ?? [] {
            
            // Notice that the float values are being used to create CLLocationDegree values.
            // This is a version of the Double type.
            let lat = CLLocationDegrees(student.latitude)
            let long = CLLocationDegrees(student.longitude )
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = student.firstName
            let last = student.lastName 
            let mediaURL = student.mediaURL 
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        
        // When the array is complete, we add the annotations to the map.
        self.mapView.addAnnotations(annotations)
        

        
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    func mapView(mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == annotationView.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            app.openURL(NSURL(string: annotationView.annotation!.subtitle!!)!)
        }
    }
}

