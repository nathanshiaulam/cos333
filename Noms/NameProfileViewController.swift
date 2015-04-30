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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldShouldReturn(textField: UITextField)-> Bool {
        textField.resignFirstResponder();
        
        var query = PFQuery(className:"Preferences");
        var currentID = PFUser.currentUser()!.objectId;
        query.whereKey("ID", equalTo:currentID!);
        query.whereKey("Name", equalTo:textField.text);
        
        var preference = query.getFirstObject();
        println(currentID!);
        println(textField.text);
        println(preference);
        
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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "toNewProfileSettings") {
            let VC = segue.destinationViewController as! PreferenceMenuViewController;
            VC.currentProfileName = nameProfileField.text;
            VC.fromNew = true;
            VC.price = 1;
            VC.distance = 1;
            VC.cuisine = ["Chinese"];
            
            // OPTIONAL FIELDS
            VC.ambience  = [];
            VC.options = "000000";
        }
    
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
