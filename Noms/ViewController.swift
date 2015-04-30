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
    
    // LOCAL CONSTANTS
    var currentProfileName:String!;
    var latitude:Double!;
    var longitude:Double!;
    var restaurantList:[String]!;
    var indexOfRestaurant:Int!;
    
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
        if (indexOfRestaurant < 20) {
            indexOfRestaurant = indexOfRestaurant + 1;
        }
        else {
            indexOfRestaurant = 0;
        }
        var currentRestaurantID = restaurantList[indexOfRestaurant];
        findRestaurantWithID(currentRestaurantID);
    }
    
    // THIS FUNCTION IS CALLED WHEN YOU POP FROM PREFERENCES OR WHEN YOU HIT THE REFRESH BUTTON
    func updateProfilePage() {
        
        // SETS INDEX OF ARRAY TO ZERO AT START
        indexOfRestaurant = 0;
        
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
        
        // FORMATS THE VIEW ACCORDING TO RESTAURANT
        findTopImage();
    }
    
    // RUNS NTH CALL
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
                
                // GET DATE INFO
                let date = NSDate();
                let calendar = NSCalendar.currentCalendar();
                let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitWeekday, fromDate:date)
                let hour = components.hour;
                let minutes = components.minute;
                let day = components.weekday;
                let nsDay = NSInteger(day);
                // FORMAT TIME STRING
                var hourString = String(hour);
                var minuteString = String(minutes);
                if hour < 10 {
                    hourString = "0" + hourString;
                }
                let timeString = hourString + ":" + minuteString;
                
                // SET COMPONENTS OF RESPONSE OBJECT
                PFCloud.callFunctionInBackground("MatchRestaurant", withParameters:["loc":[String(stringInterpolationSegment: self.latitude), String(stringInterpolationSegment: self.longitude)], "objid":[String(stringInterpolationSegment: preference.objectId)], "currtime":[String(stringInterpolationSegment: timeString)], "day":[String(stringInterpolationSegment: day)]]) {
                    (result: AnyObject?, error: NSError?) -> Void in
                    if error == nil {
                        self.restaurantList = result as! [String];
                        var currentRestaurantID = self.restaurantList[0];
                        self.findRestaurantWithID(currentRestaurantID);
                    }
                }
                
            }
        }
    }
    
    // QUERIES FOR RESTAURANT
    func findRestaurantWithID(var restaurantID: String) {
        var query = PFQuery(className: "Restaurants");
        query.whereKey("objectId", equalTo: restaurantID);
        query.getFirstObjectInBackgroundWithBlock{
            (restaurant: PFObject?, error: NSError?) -> Void in
            if error != nil || restaurant == nil {
                println(error);
            } else if let restaurant = restaurant{
                
                // LOADS IN FIELDS OF RESTAURANT
                self.restaurantNameLabel.text = restaurant["name"] as! String;
                let url = NSURL(string: restaurant["big_image_url"] as! String);
                let data = NSData(contentsOfURL: url!);
                self.restaurantImage.image = UIImage(data:data!);
                
                // FORMAT IMAGE WITH FUNCTION http://www.appcoda.com/ios-programming-circular-image-calayer/
                // FOLLOW THE GUIDE ABOVE, SHOULD TAKE IN AN IMAGE AS A PARAMETER AND RETURN AN IMAGE WITH THE RIGHT DIMENSIONS
                self.formatImage(self.restaurantImage);
                // CALCULATE DISTANCE AND SET DISTANCE TEXT
                
            }
        }

    }
    
    // FORMATS IMAGE, RETURNS UIIMAGEVIEW WTIH DESIRED PROPERTIES
    func formatImage(var restaurantImage: UIImageView) {
        
    }
    
    // RETURNS A STRING IN THE FORMAT OF "[distance] miles away"
    func calcDistance(var userDistance: PFGeoPoint, var restaurantDistance: PFGeoPoint) {
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // SETS INDEX OF ARRAY TO ZERO AT START
        indexOfRestaurant = 0;
        
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
        
        // FORMATS THE VIEW ACCORDING TO RESTAURANT
        findTopImage();
        
        // SEGUE IF USER IS NOT LOGGED IN
        if (!self.userLoggedIn()) {
            self.performSegueWithIdentifier("toUserLogin", sender: self);
        }
        
        // ADDS IN NOTIFICATION CENTER
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showTutorial", name: "showTutorial", object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateProfilePage", name: "updateProfilePage", object: nil);

        // Do any additional setup after loading the view.
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
