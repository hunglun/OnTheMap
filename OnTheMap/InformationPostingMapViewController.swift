//
//  InformationPostingMapViewController.swift
//  OnTheMap
//
//  Created by hunglun on 1/12/16.
//  Copyright © 2016 hunglun. All rights reserved.
//
import UIKit
import MapKit

class InformationPostingMapViewController : UIViewController,MKMapViewDelegate {

    @IBOutlet var mapView: MKMapView!

    var locationCoordinate : CLLocationCoordinate2D!
//    var firstName : String!
//    var lastName : String!
//    var mediaURL : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var annotations = [MKPointAnnotation]()
        
        
    
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationCoordinate
//        annotation.title = "\(firstName) \(lastName)"
//        annotation.subtitle = mediaURL
        annotations.append(annotation)
        
        // When the array is complete, we add the annotations to the map.
        self.mapView.addAnnotations(annotations)
        self.mapView.centerCoordinate = locationCoordinate

    }
    
    @IBAction func submit(sender: AnyObject) {
        //TODO: submit new location
        
    }
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    // MARK: - MKMapViewDelegate
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
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
    
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == annotationView.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            app.openURL(NSURL(string: annotationView.annotation!.subtitle!!)!)
        }
    }

}