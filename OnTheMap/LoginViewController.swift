//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by hunglun on 1/10/16.
//  Copyright © 2016 hunglun. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var waitingAnimation: UIActivityIndicatorView!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    override func viewDidLoad() {
        waitingAnimation.hidden = true
        passwordTextField.delegate = self
        passwordTextField.secureTextEntry = true
        emailTextField.delegate = self
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    @IBAction func signUpAccount(sender: AnyObject) {
        let signUpURL = "https://www.google.com/url?q=https://www.udacity.com/account/auth%23!/signin&sa=D&ust=1452592175802000&usg=AFQjCNF4P-G8QbOSHdZPa1TAOB4wnzzDVQ"
        let app = UIApplication.sharedApplication()
        app.openURL(NSURL(string: signUpURL)!)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldDidBeginEditing(textField: UITextField)  {

    }

    func getUserInfoFromUdacity(id : String) {
    
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/users/\(id)")!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5))  /* subset response data! */
           // print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            do {
                
                if let parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments) as? NSDictionary,
                    userInfo = parsedResult["user"] as? NSDictionary{
                    Model.sharedInstance().firstName = userInfo["first_name"] as! String
                    Model.sharedInstance().lastName = userInfo["last_name"] as! String
                }
            }catch {
                print("Failed to parse json data from Udacity User Info request")
            }
        
            
        }
        task.resume()

    
    }


    @IBAction func login(sender: AnyObject) {
        print(" Logging in..")
        waitingAnimation.hidden = false
        waitingAnimation.startAnimating()
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(emailTextField.text!)\", \"password\": \"\(passwordTextField.text!)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                print(error)
                
                let alert = UIAlertController(title: "", message: "Invalid Password or Email", preferredStyle: .Alert)
                let dismissAction = UIAlertAction(title: "Dismiss", style: .Cancel, handler: {(alert: UIAlertAction!) in self.dismissViewControllerAnimated(true, completion: nil)
                })
                alert.addAction(dismissAction)
                self.presentViewController(alert, animated: true, completion: nil)
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
                        self.getUserInfoFromUdacity(id)
                        let tabBarController = self.storyboard!.instantiateViewControllerWithIdentifier("TabBarController")
                        self.presentViewController(tabBarController, animated: true, completion: nil)
                    }
                else{
                    
                    let alert = UIAlertController(title: "", message: "Bad Connection", preferredStyle: .Alert)
                    let dismissAction = UIAlertAction(title: "Dismiss", style: .Cancel, handler: {(alert: UIAlertAction!) in self.dismissViewControllerAnimated(true, completion: nil)
                    })
                    alert.addAction(dismissAction)
                    self.presentViewController(alert, animated: true, completion: nil)

                
                }
                

            }catch{
                print("Failed to parse JSON data from Udacity Session Request Response")
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                self.waitingAnimation.stopAnimating()
            }
        }
        task.resume()
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    


}

