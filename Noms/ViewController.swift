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
import MapKit

class ViewController: UIViewController {
    
    // LOCAL CONSTANTS
    var address:String!;
    var currentProfileName:String!;
    var latitude:Double!;
    var longitude:Double!;
    var restaurantList:[String]! = ["kepseEzLQJ"];
    var rejectedRestList:[String]!;
    var indexOfRestaurant:Int!;
    var currentRestaurantID:String!;
    var placemarkMade:CLPlacemark!;
    var distSend:Double!;
    var preferenceID:String!;
    var firstCall:Bool!;
    var tries:Int!;
    
    // PROFILE NAME LABEL
    @IBOutlet weak var profileNameLabel: UILabel!
    
    // RESTAURANT IMAGE AND LABEL
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var restaurantDistance: UILabel!
    @IBOutlet weak var grayOverlay: UIView!
    
    // LOGS USER OUT
    @IBAction func userLogOut(sender: UIButton) {
        for key in NSUserDefaults.standardUserDefaults().dictionaryRepresentation().keys {
            NSUserDefaults.standardUserDefaults().removeObjectForKey(key.description)
        }
        PFUser.logOut();
        self.performSegueWithIdentifier("toUserLogin", sender: self);
    }
    
    //ON CLICK GREEN BUTTON
    @IBAction func goToMap(sender: UIButton) {
        if (self.restaurantNameLabel.text == "No More Restaurants in Area!") {
            let errorString = "Sorry, but we're out of options! Update your preferences to find more food.";
            var alert = UIAlertController(title: "Find more food", message: errorString as String, preferredStyle: UIAlertControllerStyle.Alert);
            alert.addAction(UIAlertAction(title:"Ok", style: UIAlertActionStyle.Default, handler: nil));
            self.presentViewController(alert, animated: true, completion: nil);
            return;
        }

        if (self.restaurantList == nil || (count(self.restaurantList) == 1 && self.restaurantList[0] == "kepseEzLQJ")) {
            return;
        }
        let length = count(self.address)
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(self.address, completionHandler:
            {(placemarks: [AnyObject]!, error: NSError!) in
                if error != nil {
                    println("Geocode failed with error: \(error.localizedDescription)")
                    
                } else if placemarks.count > 0 {
                    self.placemarkMade = placemarks[0] as! CLPlacemark;
                    let location = self.placemarkMade.location;
                    self.showMap();
                }
        })
    }
    // ON CLICK BLUE (info) BUTTON
    @IBAction func more_details(sender: UIButton) {
        if (self.restaurantNameLabel.text == "No More Restaurants in Area!") {
            let errorString = "Sorry, but we're out of options! Update your preferences and find new restaurants.";
            var alert = UIAlertController(title: "Find more food", message: errorString as String, preferredStyle: UIAlertControllerStyle.Alert);
            alert.addAction(UIAlertAction(title:"Ok", style: UIAlertActionStyle.Default, handler: nil));
            self.presentViewController(alert, animated: true, completion: nil);
        }
        if (self.restaurantList == nil || (count(self.restaurantList) == 1 && self.restaurantList[0] == "kepseEzLQJ")) {
            return;
        }
        let defaults = NSUserDefaults.standardUserDefaults();
//        defaults.setObject(currentRestaurantID, forKey: "rest_id");
        defaults.setDouble(self.distSend, forKey:"dist_string");
        NSNotificationCenter.defaultCenter().postNotificationName("updateDetailInfo", object: nil);
    }
    
    // ON CLICK RED (retry) BUTTON
    @IBAction func refreshOption(sender: AnyObject) {
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults();
        
        var updates: String = defaults.objectForKey("updated") as! String;
        if (self.restaurantList == nil || (count(self.restaurantList) == 1 && self.restaurantList[0] == "kepseEzLQJ")) {
            return;
        }
        if (self.restaurantNameLabel.text == "No More Restaurants in Area!" && updates == "false") {
            NSLog("Here");
            return;
        }
        NSLog("Index" + String(self.indexOfRestaurant));
        if (self.indexOfRestaurant == count(self.restaurantList) && updates == "true") {
            return;
        }
        var previousRestaurantID = self.restaurantList[self.indexOfRestaurant];
        self.rejectedRestList.append(previousRestaurantID);
        self.updateWeights(previousRestaurantID);
        var arrLength = count(self.restaurantList);
        if (self.indexOfRestaurant < arrLength - 1 && self.tries < 10) {
            self.indexOfRestaurant = self.indexOfRestaurant + 1;
        }
        else {
            self.indexOfRestaurant = 0;
            self.tries = 0;
            NSLog("Index" + String(self.indexOfRestaurant));
            self.findTopImage();
            arrLength = count(self.restaurantList);
        }
        var currentRestaurantID = self.restaurantList[self.indexOfRestaurant];
        while (count(self.rejectedRestList) >= 10 && contains(self.rejectedRestList, currentRestaurantID)) {
            self.indexOfRestaurant = self.indexOfRestaurant + 1;
            if (self.indexOfRestaurant >= arrLength) {
                self.restaurantNameLabel.text = "No More Restaurants in Area!";
                self.restaurantDistance.text = "";
                return;
            }
            currentRestaurantID = self.restaurantList[self.indexOfRestaurant];
        }
        
        //NSLog(currentRestaurantID);
        
        defaults.setObject(currentRestaurantID, forKey:"rest_id");
        
        self.tries = self.tries + 1;
        findRestaurantWithID(currentRestaurantID);
        NSLog("Index3 " + String(self.indexOfRestaurant));
    }
    
    func showMap() {
        let place = MKPlacemark(placemark: placemarkMade);
        let mapItem = MKMapItem(placemark: place)
        let options = [MKLaunchOptionsDirectionsModeKey:
        MKLaunchOptionsDirectionsModeDriving]
        mapItem.openInMapsWithLaunchOptions(options)
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
    func updateWeights(var restaurantID: String) {
        NSLog("In Function: Update Weights");
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults();
        var query = PFQuery(className:"Preferences");
        var currentID = PFUser.currentUser()!.objectId;
        query.whereKey("ID", equalTo:currentID!);
        query.whereKey("Name", equalTo:currentProfileName);
        
        PFCloud.callFunctionInBackground("ChangeWeights", withParameters:["loc":[String(stringInterpolationSegment: self.latitude), String(stringInterpolationSegment: self.longitude)], "prefid":[String(stringInterpolationSegment: self.preferenceID)], "restid":[String(stringInterpolationSegment: restaurantID)]]) {
                (result: AnyObject?, error: NSError?) -> Void in
                if error == nil {
                    //println(result);
                }
            }
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
                self.preferenceID = String(stringInterpolationSegment: preference.objectId!);
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
                        println(result);
                        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults();
                        self.restaurantList = result as! [String];
                        if (self.firstCall == true) {
                            self.firstCall = false;
                            self.currentRestaurantID = self.restaurantList[0];
                            defaults.setObject(self.currentRestaurantID, forKey:"rest_id");
                            self.findRestaurantWithID(self.currentRestaurantID); // FINDS RESTAURANT WITH ID
                        }
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
                
                self.address = restaurant["full_address"] as! String;
                
                // CALCULATE DISTANCE AND SET DISTANCE TEXT
                let latit1 = restaurant["latitude"] as! Double;
                let longi1 = restaurant["longitude"] as! Double;
                
                let loc1 = PFGeoPoint(latitude: latit1, longitude: longi1);
                let loc2 = PFGeoPoint(latitude: self.latitude, longitude: self.longitude);
                var distString_orig:String = String(format:"%.1f", loc1.distanceInMilesTo(loc2));
                
                let distString = distString_orig + " miles away";
                self.restaurantDistance.text = distString;
                self.distSend = loc1.distanceInMilesTo(loc2);
            }
        }

    }
    
    // FORMATS IMAGE, RETURNS UIIMAGEVIEW WTIH DESIRED PROPERTIES
    func formatImage(var restaurantImage: UIImageView) {
        restaurantImage.layer.cornerRadius = restaurantImage.frame.size.width / 2;
        restaurantImage.clipsToBounds = true;
    }
    
    // FORMATS IMAGE, RETURNS UIIMAGEVIEW WTIH DESIRED PROPERTIES
    func formatView(var view: UIView) {
        view.layer.cornerRadius = view.frame.size.width / 2;
        view.clipsToBounds = true;
    }
    override func viewDidAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showTutorial", name: "showTutorial", object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateProfilePage", name: "updateProfilePage", object: nil);
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults();
        defaults.setObject("true", forKey:"updated");
        var updates = defaults.objectForKey("updated") as! String;
        if self.restaurantNameLabel.text == "Loading..." {
            self.firstCall = true;
        }
        if (self.restaurantNameLabel.text == "No More Restaurants in Area!" && updates == "true") {
            self.restaurantNameLabel.text = "Loading...";
            self.indexOfRestaurant = 0;
            self.firstCall = true;
            self.tries = 0;
            self.rejectedRestList = [];
            
            // SETS UP DATASTORE
            var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults();
            // FINDS CURRENT PROFILE NAME
            if let currentProfileNameIsNotNil = defaults.objectForKey("Name") as? String {
                currentProfileName = defaults.objectForKey("Name") as! String
            }
            self.profileNameLabel.text = currentProfileName;
            if currentRestaurantID != nil {
                defaults.setObject(currentRestaurantID, forKey: "rest_id");
            } else {
                defaults.setObject("kepseEzLQJ", forKey:"rest_id");
            }
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
        NSLog("Appeared");
        super.viewDidAppear(true);
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        formatView(grayOverlay); 
        self.restaurantNameLabel.numberOfLines = 0;
        restaurantNameLabel.textAlignment = NSTextAlignment.Center;
        
        // SETS UP DATASTORE
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults();
        defaults.setObject("true", forKey: "updated");
        
        // CREATES LISTENERS WHEN SEGUING FROM OTHER VCS
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showTutorial", name: "showTutorial", object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateProfilePage", name: "updateProfilePage", object: nil);
        // SEGUE IF USER IS NOT LOGGED IN
        if (!self.userLoggedIn()) {
            self.performSegueWithIdentifier("toUserLogin", sender: self);
        }
        else {
            
            self.rejectedRestList = [];
            // SETS INDEX OF ARRAY TO ZERO AT START
            self.indexOfRestaurant = 0;
            self.firstCall = true;
            self.tries = 0;
            
            
            // FINDS CURRENT PROFILE NAME
            if let currentProfileNameIsNotNil = defaults.objectForKey("Name") as? String {
                currentProfileName = defaults.objectForKey("Name") as! String
            }
            self.profileNameLabel.text = currentProfileName;
            if currentRestaurantID != nil {
                defaults.setObject(currentRestaurantID, forKey: "rest_id");
            } else {
                defaults.setObject("kepseEzLQJ", forKey:"rest_id");
            }
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
        if segue.identifier == "toDetails" {
            if (count(self.restaurantList) == 1 && self.restaurantList[0] == "kepseEzLQJ") {
            let errorString = "Please wait for a restaurant to load!"
            var alert = UIAlertController(title: "Still loading.", message: errorString as String, preferredStyle: UIAlertControllerStyle.Alert);
            alert.addAction(UIAlertAction(title:"Ok", style: UIAlertActionStyle.Default, handler: nil));
            self.presentViewController(alert, animated: true, completion: nil);
            }
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
