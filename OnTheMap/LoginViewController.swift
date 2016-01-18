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
        waitingAnimation.hidesWhenStopped = true
        passwordTextField.delegate = self
        passwordTextField.secureTextEntry = true
        emailTextField.delegate = self
        super.viewDidLoad()

    }

    // sign up an Udacity Account
    @IBAction func signUpAccount(sender: AnyObject) {

        let signUpURL = Model.sharedInstance().signUpURL
        let app = UIApplication.sharedApplication()
        app.openURL(NSURL(string: signUpURL)!)

    }

    //TODO: move this function to a client model? Keep login view controller as clean as possible.
    func getUserInfoFromUdacity(id : String) {
    
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/users/\(id)")!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error...
                let alert = Model.sharedInstance().warningAlertView(self, messageString: "Bad Connection")
                dispatch_async(dispatch_get_main_queue(), {
                    self.presentViewController(alert, animated: true, completion: nil)
                })
                return
            }
            
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5))  /* subset response data! */
            do {
                if let parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments) as? NSDictionary,
                    userInfo = parsedResult["user"] as? NSDictionary{

                    Model.sharedInstance().firstName = userInfo["first_name"] as! String
                    Model.sharedInstance().lastName = userInfo["last_name"] as! String
                    dispatch_async(dispatch_get_main_queue(), {
                        let tabBarController = self.storyboard!.instantiateViewControllerWithIdentifier("TabBarController")
                        self.presentViewController(tabBarController, animated: true, completion: nil)
                        self.waitingAnimation.stopAnimating()
                    })
                }else{
                    let alert = Model.sharedInstance().warningAlertView(self, messageString: "Invalid JSON Object")
                    dispatch_async(dispatch_get_main_queue(), {
                        self.presentViewController(alert, animated: true, completion: nil)
                    })
                }
            }catch {
                let alert = Model.sharedInstance().warningAlertView(self, messageString: "Error parsing JSON Object")
                dispatch_async(dispatch_get_main_queue(), {
                    self.presentViewController(alert, animated: true, completion: nil)
                })

                print("Failed to parse json data from Udacity User Info request")
            }
        
            
        }
        task.resume()

    
    }
    
    // MARK: LoginViewController
    
    func loginSuccessHandler(success: Bool, errString : String?) {
        if success {
            self.getUserInfoFromUdacity(Model.sharedInstance().userId)
        }else{
            let alert = UIAlertController(title: "", message: errString, preferredStyle: .Alert)
            let dismissAction = UIAlertAction(title: "Dismiss", style: .Cancel, handler: {(alert: UIAlertAction!) in self.dismissViewControllerAnimated(true, completion: nil)})
            alert.addAction(dismissAction)
            if let _ = errString {
                print(errString)
                alert.message = errString
            } else{
                alert.message = "Unknown Error"
            }
            dispatch_async(dispatch_get_main_queue(), {                
                self.presentViewController(alert, animated: true, completion: nil)
                self.waitingAnimation.stopAnimating()
            })

        }
    }


    @IBAction func login(sender: AnyObject) {
        waitingAnimation.hidden = false
        waitingAnimation.startAnimating()
        Model.sharedInstance().authenticate(emailTextField!.text!,password: passwordTextField!.text!,loginSuccessHandler: loginSuccessHandler)
    }
    
    //TODO: configure the UI
    func configureUI(){
    
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    


}

