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
        self.configureUI()
        super.viewDidLoad()

    }

    // sign up an Udacity Account
    @IBAction func signUpAccount(sender: AnyObject) {

        let signUpURL = Model.sharedInstance().signUpURL
        let app = UIApplication.sharedApplication()
        app.openURL(NSURL(string: signUpURL)!)

    }

    func errorHandler(errorString : String) {
        let alert = Model.sharedInstance().warningAlertView(self, messageString: errorString)
        dispatch_async(dispatch_get_main_queue(), {

            self.waitingAnimation.stopAnimating()

            self.presentViewController(alert, animated: true, completion: nil)
        })
    }

 
    
    @IBAction func signInWithFacebook(sender: UIButton) {
       //TODO: 365362206864879
    }
    // MARK: LoginViewController
    
    func loginSuccessHandler(success: Bool, errString : String?) {
        if success {
            Model.sharedInstance().httpGetUdacityUserInfo(Model.sharedInstance().userId, errorHandler:  errorHandler) {
                dispatch_async(dispatch_get_main_queue(), {

                    self.waitingAnimation.stopAnimating()

                    let tabBarController = self.storyboard!.instantiateViewControllerWithIdentifier("TabBarController")

                    self.presentViewController(tabBarController, animated: true, completion: nil)
                })
            }

        }else{

            self.errorHandler(errString ?? "Unknown error")

        }
    }


    @IBAction func login(sender: AnyObject) {
        
        if let password = self.passwordTextField.text where password == "" {

            let alert = Model.sharedInstance().warningAlertView(self,messageString: "Empty password")
            self.presentViewController(alert, animated: true, completion: nil)

        } else if let email = self.emailTextField.text where email == ""  {

            let alert = Model.sharedInstance().warningAlertView(self,messageString: "Empty email")
            self.presentViewController(alert, animated: true, completion: nil)
            
        } else if Model.sharedInstance().isNetworkAvailable() == false {
            let alert = Model.sharedInstance().warningAlertView(self,messageString: "Network not available")
            self.presentViewController(alert, animated: true, completion: nil)

        } else {
            waitingAnimation.hidden = false
            waitingAnimation.startAnimating()
            Model.sharedInstance().authenticate(emailTextField!.text!,password: passwordTextField!.text!,loginSuccessHandler: loginSuccessHandler)
        }
    }
    

    func configureUI(){
        waitingAnimation.hidden = true
        waitingAnimation.hidesWhenStopped = true
        passwordTextField.delegate = self
        passwordTextField.secureTextEntry = true
        emailTextField.delegate = self
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        self.login(self)
        return true
    }
    


}

