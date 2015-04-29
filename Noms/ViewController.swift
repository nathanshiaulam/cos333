//
//  ViewController.swift
//  Noms
//
//  Created by Nathan Lam on 4/12/15.
//  Copyright (c) 2015 COS333. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {
    
    var currentProfileName:String!;
    
    // PROFILE NAME LABEL
    @IBOutlet weak var profileNameLabel: UILabel!
    
    // RESTAURANT IMAGE AND LABEL
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var restaurantImage: UIImageView!
    
    // LOGS USER OUT
    @IBAction func userLogOut(sender: UIButton) {
        PFUser.logOut();
        self.performSegueWithIdentifier("toUserLogin", sender: self);
    }
    
    // CHECKS FOR USER LOGIN
    func userLoggedIn() -> Bool{
        var currentUser = PFUser.currentUser();
        if ((currentUser) != nil) {
            return true;
        }
        return false;
    }
    
    // SHOW TUTORIAL SEGUE VIA ALERT
    func showTutorial() {
        self.performSegueWithIdentifier("toNameProfile", sender: self);
    }
    
    override func viewDidAppear(animated: Bool) {
        // CHECKS THE DATASTORE FOR PROFILE NAME
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults();
        if let currentProfileNameIsNotNil = defaults.objectForKey("Name") as? String {
            currentProfileName = defaults.objectForKey("Name") as! String
        }
        
        self.profileNameLabel.text = currentProfileName;
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // CHECKS THE DATASTORE FOR PROFILE NAME
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults();
        if let currentProfileNameIsNotNil = defaults.objectForKey("Name") as? String {
            currentProfileName = defaults.objectForKey("Name") as! String
        }
        
        self.profileNameLabel.text = currentProfileName;

        if (!self.userLoggedIn()) {
            self.performSegueWithIdentifier("toUserLogin", sender: self);
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showTutorial", name: "showTutorial", object: nil);
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // SETS VALUES FOR SETTINGS PAGE
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toSettingsPage" {
            let VC = segue.destinationViewController as! PreferenceMenuViewController;
            VC.fromNew = false;
            
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
