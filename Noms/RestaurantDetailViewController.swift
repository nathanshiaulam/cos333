//
//  RestaurantDetailViewController.swift
//  Noms
//
//  Created by Annie Chu, Clement Lee, Evelyn Ding, Nathan Lam, and Sean Pan.
//  Copyright (c) 2015 COS333. All rights reserved.
//

import UIKit
import Parse
import MapKit
import AddressBook
import CoreLocation

class RestaurantDetailViewController: UIViewController {
    var number:String!;
    var yelp_link:String!;
    var address:String!;
    var street:String!;
    var city:String!;
    var state:String!;
    var zip:String!;
    var curr_lat:Double!;
    var curr_long:Double!;
    var placemarkMade:CLPlacemark!;
    var categories:[String]!;
    
    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var restMap: MKMapView!
    @IBOutlet weak var yelpButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var navButton: UIButton!
    
    @IBOutlet weak var distLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var restNameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults();
        defaults.setObject("true", forKey:"updated");
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateDetailInfo", name: "updateDetailInfo", object: nil);
        
        updateDetailInfo();
        
    }

    
    func updateDetailInfo() {
        categoryLabel.numberOfLines = 0;
        
        var query = PFQuery(className: "Restaurants");
        let defaults = NSUserDefaults.standardUserDefaults()
        let restaurantID: String = defaults.objectForKey("rest_id") as! String;
        query.whereKey("objectId", equalTo: restaurantID);
        query.getFirstObjectInBackgroundWithBlock{
            (restaurant: PFObject?, error: NSError?) -> Void in
            if error != nil || restaurant == nil {
                println(error);
            } else if let restaurant = restaurant{
                
                // LOADS IN FIELDS OF RESTAURANT
                let num = restaurant["phone_number"] as! String;
                self.number = self.stripNum(num);
                if self.number == nil {
                    self.callButton.hidden = true;
                }
                // Create yelp link, price label, distance label, rating label, address for navigation
                self.yelp_link = restaurant["url"] as! String;
                
                let price = restaurant["cost"] as! String;
                self.priceLabel.text = price;
                let price_length = count(price)
                let stars = restaurant["stars"] as! Double;
                self.ratingLabel.text = String(format:"%.1f stars", stars);
                self.address = restaurant["full_address"] as! String;
                var distString_orig:String = String(format:"%.1f", defaults.doubleForKey("dist_string"));
                let distString = distString_orig + " miles away";
                self.distLabel.text = distString;
                self.categories = restaurant["categories"] as! [String];
                let string_cat = ", ".join(self.categories)
                self.categoryLabel.text = string_cat;
                self.restNameLabel.text = restaurant["name"] as? String;
                
                let latitude = restaurant["latitude"] as! Double;
                let longitude = restaurant["longitude"] as! Double;
                
                let restLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude);
                
                let locationManager = CLLocationManager()
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.requestAlwaysAuthorization()
                locationManager.startUpdatingLocation()
                let locValue = locationManager.location.coordinate
                self.curr_lat = locValue.latitude as Double;
                self.curr_long = locValue.longitude as Double;
                let new_lat = 0.5 * (restLocation.latitude + self.curr_lat);
                let new_long = 0.5 * (restLocation.longitude + self.curr_long);
                let middleLocation = CLLocationCoordinate2D(latitude: new_lat, longitude: new_long);
                var distBetw = defaults.doubleForKey("dist_string") as Double;
                distBetw = distBetw * 1609.34;

                
                let region = MKCoordinateRegionMakeWithDistance(
                    middleLocation, distBetw + 30, distBetw+30);
                
                // Create pin for map of restaurant
                let locationAnnotation = MKPointAnnotation();
                //set properties of the MKPointAnnotation object
                locationAnnotation.coordinate = restLocation;
                locationAnnotation.title = self.restNameLabel.text;
                
                // Show current user location (blue dot)
                self.restMap.showsUserLocation = true;
                
                //add the annotation to the map
                self.restMap.addAnnotation(locationAnnotation);
                self.restMap.setRegion(region, animated: true)
                
                let url = NSURL(string: restaurant["big_img_url"]! as! String);
                let data = NSData(contentsOfURL: url!);
                self.restaurantImage.image = UIImage(data:data!);
            }
        }
    }
    
    func locationManager(manager: CLLocationManager!,   didUpdateLocations locations: [AnyObject]!) {
        let locValue = manager.location.coordinate
        curr_lat = locValue.latitude
        curr_long = locValue.longitude
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Send to Yelp page of restaurant
    @IBAction func click_yelp(sender: AnyObject) {
        if UIApplication.sharedApplication().openURL(NSURL(string: yelp_link)!){
            println("url successfully opened")
        } else {
            println("invalid url")
        }
    }
    
    // Navigate from current location to restaurant
    @IBAction func click_navigate(sender: UIButton) {
        let length = count(self.address)
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(self.address, completionHandler:
            {(placemarks: [AnyObject]!, error: NSError!) in
                if error != nil {
                    println("Geocode failed with error: \(error.localizedDescription)")
                    
                } else if placemarks.count > 0 {
                    self.placemarkMade = placemarks[0] as! CLPlacemark
                    let location = self.placemarkMade.location
                    self.showMap()
                }
        })
    }
    
    // Call restaurant's number
    @IBAction func click_call(sender: UIButton) {
        UIApplication.sharedApplication().openURL(NSURL(string: "tel://" + self.number)!)

    }
    
    // Show restaurant pin on map
    func showMap() {
        let place = MKPlacemark(placemark: placemarkMade);
        let mapItem = MKMapItem(placemark: place)
        let options = [MKLaunchOptionsDirectionsModeKey:
        MKLaunchOptionsDirectionsModeDriving]
        mapItem.openInMapsWithLaunchOptions(options)
    }
    
    // Strip restaurant's number from Parse
    func stripNum(var num: String) -> String{
        num = num.stringByReplacingOccurrencesOfString("(", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil);
        num = num.stringByReplacingOccurrencesOfString(")", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil);
        num = num.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil);
        num = num.stringByReplacingOccurrencesOfString("-", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil);
        return num;
    }

}
