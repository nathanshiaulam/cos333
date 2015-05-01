//
//  ViewController.swift
//  Noms
//
//  Created by Nathan Lam on 4/12/15.
//  Copyright (c) 2015 COS333. All rights reserved.
//

import UIKit
import Parse
import Darwin

class ViewController: UIViewController {
    
    // LOCAL CONSTANTS
    var currentProfileName:String!;
    var latitude:Double!;
    var longitude:Double!;
    var restaurantList:[String]!;
    var indexOfRestaurant:Int!;
    var currentRestaurantID:String!;
    var distString:String!;
    
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
    
    // ON CLICK GREEN BUTTON
    @IBAction func more_details(sender: UIButton) {
        println(currentRestaurantID);
        let defaults = NSUserDefaults.standardUserDefaults();
        defaults.setObject(currentRestaurantID, forKey: "rest_id");
        defaults.setObject(self.distString, forKey:"dist_string");
        
    }
    
    // ON CLICK RED BUTTON
    @IBAction func refreshOption(sender: AnyObject) {
        let arrLength = count(restaurantList);
        if (indexOfRestaurant < arrLength - 1) {
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
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults();

        NSLog(defaults.objectForKey("Name") as! String);
        // CHECKS THE DATASTORE FOR PROFILE NAME ON VIEW POP
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
                self.findTopImage();
            }
        }
        NSLog("Second Function Called");
        
        
    }
    
    // RUNS FINDS THE IMAGE OF THE FIRST RESTAURANT IN LIST
    func findTopImage() {
        NSLog("In Function: Second Function Called");
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
                NSLog("In First Async Call");
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
                NSLog("THIS IS YO ID SON")
                NSLog(String(stringInterpolationSegment: preference.objectId!));
                NSLog(String(stringInterpolationSegment: self.latitude));
                NSLog(String(stringInterpolationSegment: self.longitude));
                // SET COMPONENTS OF RESPONSE OBJECT AND FINDS RESTAURANT ID
                PFCloud.callFunctionInBackground("MatchRestaurant", withParameters:["loc":[String(stringInterpolationSegment: self.latitude), String(stringInterpolationSegment: self.longitude)], "objid":[String(stringInterpolationSegment: preference.objectId!)], "currtime":[String(stringInterpolationSegment: timeString)], "day":[String(stringInterpolationSegment: day)]]) {
                    (result: AnyObject?, error: NSError?) -> Void in
                    if error == nil {
                        self.restaurantList = result as! [String];
                        self.currentRestaurantID = self.restaurantList[0];
                        self.findRestaurantWithID(self.currentRestaurantID); // FINDS RESTAURANT WITH ID
                    }
                }
            }
        }
    }
    
    // QUERIES FOR RESTAURANT AND SETS IMAGE + DISTANCE
    func findRestaurantWithID(var restaurantID: String) {
        var query = PFQuery(className: "Restaurants");
        query.whereKey("objectId", equalTo: restaurantID);
        query.getFirstObjectInBackgroundWithBlock{
            (restaurant: PFObject?, error: NSError?) -> Void in
            if error != nil || restaurant == nil {
                println(error);
            } else if let restaurant = restaurant{
                NSLog("LOLOLOL NOT WORKING");
                // LOADS IN FIELDS OF RESTAURANT
                self.restaurantNameLabel.text = restaurant["name"] as? String;
                NSLog("YOU EATIN HERE SON");
                NSLog(self.restaurantNameLabel.text!);
                NSLog(String(count(String(stringInterpolationSegment: restaurant["big_img_url"]!))));
                if count(String(stringInterpolationSegment: restaurant["big_img_url"]!)) != 0{
                    let url = NSURL(string: restaurant["big_img_url"]! as! String);
                    let data = NSData(contentsOfURL: url!);
                    self.restaurantImage.image = UIImage(data:data!);
                } else if count(String(stringInterpolationSegment:restaurant["photo_url"])) != 0 {
                    let url = NSURL(string: restaurant["photo_url"] as! String);
                    let data = NSData(contentsOfURL: url!);
                    self.restaurantImage.image = UIImage(data:data!);
                }
                
                // FORMAT IMAGE WITH FUNCTION http://www.appcoda.com/ios-programming-circular-image-calayer/
                // FOLLOW THE GUIDE ABOVE, SHOULD TAKE IN AN IMAGE AS A PARAMETER AND RETURN AN IMAGE WITH THE RIGHT DIMENSIONS
                self.formatImage(self.restaurantImage); //do pointers work like this?

                // CALCULATE DISTANCE AND SET DISTANCE TEXT
                let latit1 = restaurant["latitude"] as! Double;
                let longi1 = restaurant["longitude"] as! Double;
                
                let loc1 = PFGeoPoint(latitude: latit1, longitude: longi1);
                let loc2 = PFGeoPoint(latitude: self.latitude, longitude: self.longitude);
                var distString_orig:String = String(format:"%.1f", loc1.distanceInMilesTo(loc2));
                
                self.distString = distString_orig + " miles away";
                self.restaurantDistance.text = self.distString;
            }
        }

    }
    
    // FORMATS IMAGE, RETURNS UIIMAGEVIEW WTIH DESIRED PROPERTIES
    func formatImage(var restaurantImage: UIImageView) {
        restaurantImage.layer.cornerRadius = restaurantImage.frame.size.width / 2;
        restaurantImage.clipsToBounds = true;
    }
    
    // RETURNS A STRING IN THE FORMAT OF "[distance] miles away"

    func calcDistance(var lat1: Double, var lon1: Double, var lat2: Double, var lon2: Double) -> String {
        var radlat1 = M_PI * lat1/180;
        var radlat2 = M_PI * lon1/180;
        var radlon1 = M_PI * lat2/180;
        var radlon2 = M_PI * lon2/180;
        var theta = lon1-lon2;
        var radtheta = M_PI * theta/180;
        var dist = sin(radlat1) * sin(radlat2) + cos(radlat1) * cos(radlat2) * cos(radtheta);
        dist = acos(dist);
        dist = dist * 180/M_PI;
        dist = dist * 60 * 1.1515;
        var str:String = String(format:"%f",dist);
        return str;
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        self.restaurantNameLabel.numberOfLines = 0;
        restaurantNameLabel.textAlignment = NSTextAlignment.Center;
        // CREATES LISTENERS WHEN SEGUING FROM OTHER VCS
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showTutorial", name: "showTutorial", object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateProfilePage", name: "updateProfilePage", object: nil);
        // SEGUE IF USER IS NOT LOGGED IN
        if (!self.userLoggedIn()) {
            self.performSegueWithIdentifier("toUserLogin", sender: self);
        }
        else {
            
            // SETS INDEX OF ARRAY TO ZERO AT START
            indexOfRestaurant = 0;
        
            // SETS UP DATASTORE
            var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults();
            
            // FINDS CURRENT PROFILE NAME
            if let currentProfileNameIsNotNil = defaults.objectForKey("Name") as? String {
                currentProfileName = defaults.objectForKey("Name") as! String
            }
            self.profileNameLabel.text = currentProfileName;
            
            // GETS GEOPOINT ON PAGE LOAD
            PFGeoPoint.geoPointForCurrentLocationInBackground {
                (geoPoint: PFGeoPoint?, error:NSError?) -> Void in
                if error == nil {
                    self.latitude = geoPoint?.latitude; // STORES LATITUDE
                    self.longitude = geoPoint?.longitude; // STORES LONGITUDE
                    if (self.currentProfileName != nil) {
                        self.findTopImage();
                    }
                }
            }
        }
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
            
            VC.fromNew = false; // Tells next VC that we don't create new Pref
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
