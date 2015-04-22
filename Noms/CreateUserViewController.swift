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
    
    // CREATES USER GIVEN CORRECT USER AND PASSWORD
    @IBAction func enterButtonClicked(sender: UIButton) {
        self.createUser(usernameField.text, password:passwordField.text);
    }
    func createUser(username: String, password: String) {
        var newUser = PFUser();
        
        // ENSURES FIELDS ARE NOT EMPTY
        if (count(username) == 0 || count(password) == 0) {
            var alert = UIAlertController(title: "Submission Failure", message: "Invalid username or password", preferredStyle: UIAlertControllerStyle.Alert);
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil));
            self.presentViewController(alert, animated: true, completion: nil);
            return;
        }
        var profiles = [PFObject(className:"Profile")];
        
        // CREATES FIRST PROFILE
        var firstProfile = PFObject(className:"Profile");
        firstProfile["Name"] = "";
        firstProfile["Cuisine"] = [];
        firstProfile["Cost"] = "";
        firstProfile["Distance"] = 0;
        firstProfile["Misc"] = "";
        
        profiles[0] = (firstProfile);
        
        // SETS ATTRIBUTES OF NEW USER
        newUser.username = username;
        newUser.password = password;
        newUser["profiles"] = profiles;
        
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
        if (textField == usernameField) {
            passwordField.becomeFirstResponder();
        }
        else {
            self.createUser(usernameField.text, password: passwordField.text);
        }
        return true;
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordField.secureTextEntry = true;
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
