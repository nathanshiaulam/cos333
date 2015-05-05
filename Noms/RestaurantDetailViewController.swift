//
//  RestaurantDetailViewController.swift
//  Noms
//
//  Created by Nathan Lam on 4/26/15.
//  Copyright (c) 2015 COS333. All rights reserved.
//

import UIKit
import Parse
import MapKit
import AddressBook
import MapKit
import CoreLocation

class RestaurantDetailViewController: UIViewController {
    var number:String!;
    var yelp_link:String!;
    var address:String!;
    var street:String!;
    var city:String!;
    var state:String!;
    var zip:String!;
    var placemarkMade:CLPlacemark!;
    var latitude:Double!;
    var longitude:Double!;
    var categories:[String]!;
    
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
        
        
        
        categoryLabel.numberOfLines = 0;

        var query = PFQuery(className: "Restaurants");
        let defaults = NSUserDefaults.standardUserDefaults()
        let restaurantID = defaults.stringForKey("rest_id")
        println(restaurantID);
        query.whereKey("objectId", equalTo: restaurantID!);
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
                self.yelp_link = restaurant["url"] as! String;
                //let yelp_link = NSURL(string: temp_rest_url);
                let price = restaurant["cost"] as! String;
                self.priceLabel.text = price;
                let price_length = count(price)
                let stars = restaurant["stars"] as! Double;
                self.ratingLabel.text = String(format:"%.1f stars", stars);
                self.address = restaurant["full_address"] as! String;
                self.distLabel.text = defaults.stringForKey("dist_string");
                self.categories = restaurant["categories"] as! [String];
                let string_cat = ", ".join(self.categories)
                self.categoryLabel.text = string_cat;
                self.restNameLabel.text = restaurant["name"] as! String;
                
                let latitude = restaurant["latitude"] as! Double;
                let longitude = restaurant["longitude"] as! Double;
                
                let userLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude);
                
                let region = MKCoordinateRegionMakeWithDistance(
                    userLocation, 2000, 2000)
                
                self.restMap.setRegion(region, animated: true)
                
                
            }
        }
        
        // load map from yelp site
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func click_yelp(sender: AnyObject) {
        if UIApplication.sharedApplication().openURL(NSURL(string: yelp_link)!){
            println("url successfully opened")
        } else {
            println("invalid url")
        }
    }
    
    @IBAction func click_navigate(sender: UIButton) {
        let length = count(self.address)
        let geoCoder = CLGeocoder()
        println(self.address);
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
    
    @IBAction func click_call(sender: UIButton) {
        UIApplication.sharedApplication().openURL(NSURL(string: "tel://" + self.number)!)

    }
    
    func showMap() {
        let place = MKPlacemark(placemark: placemarkMade);
        let mapItem = MKMapItem(placemark: place)
        let options = [MKLaunchOptionsDirectionsModeKey:
        MKLaunchOptionsDirectionsModeDriving]
        mapItem.openInMapsWithLaunchOptions(options)
    }
    
    func stripNum(var num: String) -> String{
        num = num.stringByReplacingOccurrencesOfString("(", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil);
        num = num.stringByReplacingOccurrencesOfString(")", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil);
        num = num.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil);
        num = num.stringByReplacingOccurrencesOfString("-", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil);
        return num;
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
