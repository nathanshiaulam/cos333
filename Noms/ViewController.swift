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
    var latitude:Double!;
    var longitude:Double!;
    // PROFILE NAME LABEL
    @IBOutlet weak var profileNameLabel: UILabel!
    
    // RESTAURANT IMAGE AND LABEL
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var restaurantDistance: UILabel!
    
    // LOGS USER OUT
    @IBAction func userLogOut(sender: UIButton) {
        PFUser.logOut();
        self.performSegueWithIdentifier("toUserLogin", sender: self);
    }
    
    // ON CLICK RED BUTTON
    @IBAction func refreshOption(sender: AnyObject) {
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
    
    // THIS FUNCTION IS CALLED WHEN YOU POP FROM PREFERENCES OR WHEN YOU HIT THE REFRESH BUTTON
    func updateProfilePage() {
        // CHECKS THE DATASTORE FOR PROFILE NAME ON VIEW POP
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults();
        if let currentProfileNameIsNotNil = defaults.objectForKey("Name") as? String {
            currentProfileName = defaults.objectForKey("Name") as! String
        }
        self.profileNameLabel.text = currentProfileName;
        
        // GETS GEOPOINT ON VIEW POP
        PFGeoPoint.geoPointForCurrentLocationInBackground {
            (geoPoint: PFGeoPoint?, error:NSError?) -> Void in
            if error == nil {
                self.latitude = geoPoint?.latitude; // STORES LATITUDE
                self.longitude = geoPoint?.longitude; // STORES LONGITUDE
            }
        }
    }
    
    func findTopImage() {
        var query = PFQuery(className:"Preferences");
        var currentID = PFUser.currentUser()!.objectId;
        query.whereKey("ID", equalTo:currentID!);
        query.whereKey("Name", equalTo:currentProfileName);
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults();

        query.getFirstObjectInBackgroundWithBlock {
            (preference: PFObject?, error: NSError?) -> Void in
            if error != nil || preference == nil {
                println(error);
            } else if let preference = preference{
                // GET STORED GEOPOINT
                var geoPoint:PFGeoPoint = defaults.objectForKey("Geo-Point") as! PFGeoPoint;
                
                // GET DATE INFO
                let date = NSDate();
                let calendar = NSCalendar.currentCalendar();
                let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitWeekday, fromDate:date)
                let hour = components.hour;
                let minutes = components.minute;
                let day = components.weekday;
                
                // SET COMPONENTS OF RESPONSE OBJECT
                var response = Dictionary<String, Any>();
                response["loc"] = [geoPoint.latitude, geoPoint.longitude];
                response["objid"] = preference.objectId;
                
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let date = NSDate();
        let calendar = NSCalendar.currentCalendar();
        let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitWeekday, fromDate:date)
        let hour = components.hour;
        let minutes = components.minute;
        let day = components.weekday;
        
        println("Hour" + String(hour));
        println("Minutes" + String(minutes));
        println("Day" + String(day));
        
        // SETS UP DATASTORE
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults();
        
        // GETS GEOPOINT ON PAGE LOAD
        PFGeoPoint.geoPointForCurrentLocationInBackground {
            (geoPoint: PFGeoPoint?, error:NSError?) -> Void in
            if error == nil {
                self.latitude = geoPoint?.latitude; // STORES LATITUDE
                self.longitude = geoPoint?.longitude; // STORES LONGITUDE
            }
        }
        
        // FINDS CURRENT PROFILE NAME
        if let currentProfileNameIsNotNil = defaults.objectForKey("Name") as? String {
            currentProfileName = defaults.objectForKey("Name") as! String
        }
        self.profileNameLabel.text = currentProfileName;
        
        // SEGUE IF USER IS NOT LOGGED IN
        if (!self.userLoggedIn()) {
            self.performSegueWithIdentifier("toUserLogin", sender: self);
        }
        
        // ADDS IN NOTIFICATION CENTER
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showTutorial", name: "showTutorial", object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateProfilePage", name: "updateProfilePage", object: nil);

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
