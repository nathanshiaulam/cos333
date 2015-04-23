//
//  LogInViewController.swift
//  Noms
//
//  Created by Nathan Lam on 4/12/15.
//  Copyright (c) 2015 COS333. All rights reserved.
//

import UIKit
import Parse
import Foundation

class LogInViewController: UIViewController {
    
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBAction func submitButtonClick(sender: UIButton) {
        userLogin(usernameField.text, password: passwordField.text);
    }
    
    func userLogin(username: String, password: String) {
        var usernameLen = count(username);
        var passwordLen = count(password);
        if (usernameLen == 0 || passwordLen == 0) {
            var alert = UIAlertController(title: "Submission Failure", message: "Invalid username or password", preferredStyle: UIAlertControllerStyle.Alert);
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil));
            self.presentViewController(alert, animated: true, completion: nil);
            return;
        }
        PFUser.logInWithUsernameInBackground(username, password: password) {
            (user, error) -> Void in
            if (user != nil) {
                self.dismissViewControllerAnimated(true, completion: nil);
            }
            else {
                var alert = UIAlertController(title: "Log-In Failure", message: "Username or password is incorrect", preferredStyle: UIAlertControllerStyle.Alert);
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil));
                self.presentViewController(alert, animated: true, completion: nil);
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var usernamePlaceholder = NSAttributedString(string: "Username", attributes: [NSForegroundColorAttributeName : UIColor.grayColor()]);
        var passwordPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName : UIColor.grayColor()]);
        usernameField.attributedPlaceholder = usernamePlaceholder;
        passwordField.attributedPlaceholder = passwordPlaceholder;
        usernameField.layer.cornerRadius = 0;
        passwordField.layer.cornerRadius = 0;
        passwordField.secureTextEntry = true;
        
        
        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField == usernameField) {
            passwordField.becomeFirstResponder();
        }
        else {
            self.userLogin(usernameField.text, password: passwordField.text);
            textField.resignFirstResponder();
        }
        return true;
    }
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
