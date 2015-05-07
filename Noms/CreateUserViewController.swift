//
//  CreateUserViewController.swift
//  Noms
//
//  Created by Nathan Lam on 4/12/15.
//  Copyright (c) 2015 COS333. All rights reserved.
//

import UIKit
import Parse

class CreateUserViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    @IBAction func onClickLogIn(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true);
    }
    // CREATES USER GIVEN CORRECT USER AND PASSWORD
    @IBAction func enterButtonClicked(sender: UIButton) {
        self.createUser(usernameField.text, password:passwordField.text, email:emailField.text);
    }
    func createUser(username: String, password: String, email: String) {
        var newUser = PFUser();
        
        // ENSURES FIELDS ARE NOT EMPTY
        if (count(username) == 0 || count(password) == 0 || count(email) == 0) {
            var alert = UIAlertController(title: "Submission Failure", message: "Invalid username, password, or email", preferredStyle: UIAlertControllerStyle.Alert);
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil));
            self.presentViewController(alert, animated: true, completion: nil);
            return;
        }
        var profiles = [PFObject(className:"Preferences")] as Array;
        
        // SETS ATTRIBUTES OF NEW USER
        newUser.username = username;
        newUser.password = password;
        newUser.email = email;
        
        newUser.signUpInBackgroundWithBlock {
            (succeeded, error) -> Void in
            if (error == nil) {
                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                    NSNotificationCenter.defaultCenter().postNotificationName("showTutorial", object: nil);
                })
                self.dismissViewControllerAnimated(true, completion: nil);
            } else {
                let errorString = error!.userInfo!["error"] as! NSString;
                var alert = UIAlertController(title: "Submission Failure", message: errorString as String, preferredStyle: UIAlertControllerStyle.Alert);
                alert.addAction(UIAlertAction(title:"Ok", style: UIAlertActionStyle.Default, handler: nil));
                self.presentViewController(alert, animated: true, completion: nil);
                // Show the errorString somewhere and let the user try again.
            }
        }

    }
    func textFieldShouldReturn(textField: UITextField)-> Bool {
        NSLog("first here");
        if (textField == usernameField) {
            NSLog("here");
            passwordField.becomeFirstResponder();
        }
        else if (textField == passwordField) {
            NSLog("here");
            emailField.becomeFirstResponder();
        }
        else {
            NSLog("here");
            self.createUser(usernameField.text, password: passwordField.text, email:emailField.text);
            textField.resignFirstResponder();
        }
        return true;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var usernamePlaceholder = NSAttributedString(string: "Username", attributes: [NSForegroundColorAttributeName : UIColor.grayColor()]);
        var passwordPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName : UIColor.grayColor()]);
        var emailPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName : UIColor.grayColor()]);
        usernameField.attributedPlaceholder = usernamePlaceholder;
        passwordField.attributedPlaceholder = passwordPlaceholder;
        emailField.attributedPlaceholder = emailPlaceholder;
        usernameField.layer.cornerRadius = 0;
        passwordField.layer.cornerRadius = 0;
        emailField.layer.cornerRadius = 0;
        passwordField.secureTextEntry = true;
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        
        // Do any additional setup after loading the view.
    }
//    func keyboardWillShow (sender: NSNotification) {
//        self.view.frame.origin.y -= 32
//    }
//    func keyboardWillHide (sender: NSNotification) {
//        self.view.frame.origin.y += 96
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true);
        
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
