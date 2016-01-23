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
                let controller = self.storyboard!.instantiateViewControllerWithIdentifier("TabBarController")
                self.presentViewController(controller, animated: false, completion: nil)
            }
        }
    
    }
    
    func query(userId : String) {
        let urlString = "https://api.parse.com/1/classes/StudentLocation?where=%7B%22uniqueKey%22%3A%22\(userId)%22%7D"
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { /* Handle error */
                let alert = Model.sharedInstance().warningAlertView(self,messageString: "Quering student id \(userId) fails.")
                dispatch_async(dispatch_get_main_queue()) {
                    self.presentViewController(alert, animated: true, completion: nil)
                }
    
                return
            }
            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
            do {
                if let parsedResult = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? NSDictionary,
                    objectId = parsedResult["results"]?[0]?["objectId"] as? String{
                    print("Updating...")
                    self.update(objectId)
                }else{
                    print("Posting...")
                    self.post()
                }
            }catch{

                let alert = Model.sharedInstance().warningAlertView(self,messageString: "Fail to parse JSON response from query")
                dispatch_async(dispatch_get_main_queue()) {
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                

            }
            
        }
        task.resume()

    
    }


    func post() {

        let userid = Model.sharedInstance().userId
        let firstName = Model.sharedInstance().firstName
        let lastName = Model.sharedInstance().lastName
        let mediaURL = urlTextField.text ?? "Undefined"

        let requestBody = "{\"uniqueKey\": \"\(userid)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(self.mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(self.mapView.centerCoordinate.latitude), \"longitude\": \(self.mapView.centerCoordinate.longitude)}"
        
        Model.sharedInstance().httpPostStudentLocation(self ,requestBody: requestBody, errorString: "Posting information fails"){
            dispatch_async(dispatch_get_main_queue()) {
                let controller = self.storyboard!.instantiateViewControllerWithIdentifier("TabBarController")
                self.presentViewController(controller, animated: false, completion: nil)
            }
        }
    
    }
    @IBAction func submit(sender: AnyObject) {

        query(Model.sharedInstance().userId)                
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