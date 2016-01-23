//
//  InformationPostingMapViewController.swift
//  OnTheMap
//
//  Created by hunglun on 1/12/16.
//  Copyright © 2016 hunglun. All rights reserved.
//
import UIKit
import MapKit

class InformationPostingMapViewController : UIViewController,MKMapViewDelegate,UITextFieldDelegate {

    @IBOutlet var mapView: MKMapView!
    @IBOutlet var urlTextField : UITextField!
    var mapString : String!
    var locationCoordinate : CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var annotations = [MKPointAnnotation]()
        
        
        urlTextField.delegate = self
    
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationCoordinate
        annotations.append(annotation)
        
        // When the array is complete, we add the annotations to the map.
        self.mapView.addAnnotations(annotations)
        self.mapView.centerCoordinate = locationCoordinate
        
        

    }

    
    func update(objectId : String){
        let userid = Model.sharedInstance().userId
        let firstName = Model.sharedInstance().firstName
        let lastName = Model.sharedInstance().lastName
        let mediaURL = urlTextField.text ?? "Undefined"
        
        let requestBody = "{\"uniqueKey\": \"\(userid)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(self.mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(self.mapView.centerCoordinate.latitude), \"longitude\": \(self.mapView.centerCoordinate.longitude)}"

        
        Model.sharedInstance().httpPutStudentLocation(self,objectId : objectId,requestBody: requestBody, errorString: "Updating information fails"){
            dispatch_async(dispatch_get_main_queue()) {

                Model.sharedInstance().getStudentLocations(self){
                    dispatch_async(dispatch_get_main_queue()){

                        self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)

                    }
                }

            }
        }
    
    }
    




    func post() {

        let userid = Model.sharedInstance().userId
        let firstName = Model.sharedInstance().firstName
        let lastName = Model.sharedInstance().lastName
        let mediaURL = urlTextField.text ?? "Undefined"

        let requestBody = "{\"uniqueKey\": \"\(userid)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(self.mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(self.mapView.centerCoordinate.latitude), \"longitude\": \(self.mapView.centerCoordinate.longitude)}"
        
        Model.sharedInstance().httpPostStudentLocation(self ,requestBody: requestBody, errorString: "Posting information fails"){
            dispatch_async(dispatch_get_main_queue()) {
                Model.sharedInstance().getStudentLocations(self){
                    dispatch_async(dispatch_get_main_queue()){
                        self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
                    }
                }


            }
        }
    
    }
    @IBAction func submit(sender: AnyObject) {
        let userId = Model.sharedInstance().userId

        if let url = urlTextField.text where url != "" {
            Model.sharedInstance().httpQueryStudent(self, userId: userId, errorString:"Quering student id \(userId) fails."){
                (userExists : Bool, objectId : String?) in
                if userExists {
                    self.update(objectId!)
                }else{
                    self.post()
                }
            }
        }else{
            let alert = Model.sharedInstance().warningAlertView(self, messageString: "Please do not leave URL textfield empty")
            self.presentViewController(alert, animated: true, completion: nil)
        }


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
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        urlTextField.text = ""
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}