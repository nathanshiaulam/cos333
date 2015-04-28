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
        
        // CREATES FIRST PROFILE
        var firstProfile = PFObject(className:"Preferences");
        firstProfile["ID"] = PFUser.currentUser()!.objectId;
        firstProfile["Name"] = textField.text;
        firstProfile["Cuisine"] = "";
        firstProfile["Cost"] = 1;
        firstProfile["Distance"] = 1;
        firstProfile["Parking"] = "";
        firstProfile["Ambience"] = "";
        firstProfile["Caters"] = -1;
        firstProfile["CreditCards"] = -1;
        firstProfile["Delivery"] = -1;
        firstProfile["GoodFor"] = -1;
        firstProfile["Groups"] = -1;
        firstProfile["Kids"] = -1;
        firstProfile["OutdoorSeating"] = -1;
        firstProfile["Reservations"] = -1;
        firstProfile["TakeOut"] = -1;
        firstProfile["WaiterService"] = -1;
        firstProfile["Wheelchair"] = -1;
        firstProfile["Wifi"] = -1;
        firstProfile["Alcohol"] = -1;
        
        
        if (count(textField.text) > 0) {
        self.performSegueWithIdentifier("toNewProfileSettings", sender: self);
        }
        return true;
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "toNewProfileSettings") {
            let VC = segue.destinationViewController as! PreferenceMenuViewController;
            VC.newProfileName = nameProfileField.text;
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
