//
//  NameProfileViewController.swift
//  Noms
//
//  Created by Nathan Lam on 4/16/15.
//  Copyright (c) 2015 COS333. All rights reserved.
//

import UIKit
import Parse
import Bolts

class NameProfileViewController: UIViewController {

    @IBOutlet weak var nameProfileField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        nameProfileField.layer.cornerRadius = 0;
        nameProfileField.textColor = UIColor.whiteColor();
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true);
        
    }
    
    // only allow creation of profile if one with the given name doesn't already exist
    func textFieldShouldReturn(textField: UITextField)-> Bool {
        textField.resignFirstResponder();
        
        var query = PFQuery(className:"Preferences");
        var currentID = PFUser.currentUser()!.objectId;
        query.whereKey("ID", equalTo:currentID!);
        query.whereKey("Name", equalTo:textField.text);
        
        var preference = query.getFirstObject();
        
        if (preference != nil) {
            let errorString = "Already Exists";
            var alert = UIAlertController(title: "Can't Create Profile", message: errorString as String, preferredStyle: UIAlertControllerStyle.Alert);
            alert.addAction(UIAlertAction(title:"Ok", style: UIAlertActionStyle.Default, handler: nil));
            self.presentViewController(alert, animated: true, completion: nil);
        }


        
        if (count(textField.text) > 0) {
        self.performSegueWithIdentifier("toNewProfileSettings", sender: self);
        }
        return true;
    }
    
    // creates a new profile and prepares for editing
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "toNewProfileSettings") {

            let VC = segue.destinationViewController as! PreferenceMenuViewController;
            VC.currentProfileName = nameProfileField.text;
            VC.fromNew = true;

            var defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(nameProfileField.text, forKey: "Name");
            defaults.setObject(1, forKey:"Price");
            defaults.setObject(5, forKey:"Distance");
            defaults.setObject([""], forKey:"Cuisine");
            defaults.setObject([], forKey:"Ambience");
            defaults.setObject("000000", forKey:"Options");
            
           
        }
    
    }

}
