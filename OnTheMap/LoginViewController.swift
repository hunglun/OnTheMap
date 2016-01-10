//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by hunglun on 1/10/16.
//  Copyright © 2016 hunglun. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    override func viewDidLoad() {
        passwordTextField.delegate = self
        passwordTextField.secureTextEntry = true
        emailTextField.delegate = self
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldDidBeginEditing(textField: UITextField)  {

        if (textField == passwordTextField){
            passwordTextField.placeholder = ""
        }
        if (textField == emailTextField){
            emailTextField.placeholder = ""
        }
    }

    @IBAction func login(sender: AnyObject) {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(emailTextField.text!)\", \"password\": \"\(passwordTextField.text!)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                print(error)
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            do {
                if let parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments) as? NSDictionary,
                    session = parsedResult["account"],
                    id = session["key"] as? String{
                        print(id)
                        let navigationController = self.storyboard!.instantiateViewControllerWithIdentifier("NavigationController") as! UINavigationController
                        Model.sharedInstance().userId = id
                        self.presentViewController(navigationController, animated: true, completion: nil)
                    }
                

            }catch{
                
            }
        }
        task.resume()
        
    }

}

