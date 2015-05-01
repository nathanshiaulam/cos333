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
                self.number = "4086468663"
                if self.number == nil {
                    // delete call button
                }
                self.yelp_link = restaurant["url"] as! String;
                //let yelp_link = NSURL(string: temp_rest_url);
                let price = restaurant["cost"] as! String;
                let price_length = count(price)
                let stars = restaurant["stars"] as! Double;
                let address = restaurant["full_address"] as! String;
                
            }
        }
        
        
        // make map show up
        
        
        
        // figure out how to add categories array
        /*let categories = restaurant["categories"] as!*/
        
        
        // load map from yelp site

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func click_yelp(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: yelp_link)!)/*{
            println("url successfully opened")
        } else {
            println("invalid url")
        }*/
    }
    
    
    @IBAction func click_call(sender: UIButton) {
        var url:NSURL = NSURL(string: "tel://" + self.number)!
        UIApplication.sharedApplication().openURL(url)
    }
    
    @IBAction func click_navigate(sender: UIButton) {
        let length = count(address)
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address, completionHandler:
            {(placemarks: [AnyObject]!, error: NSError!) in
                if error != nil {
                    println("Geocode failed with error: \(error.localizedDescription)")
                } else if placemarks.count > 0 {
                    let placemarkMade = placemarks[0] as! CLPlacemark
                    let location = placemarkMade.location
                    self.showMap()
                }
        })
    }
    
    func showMap() {
        let place = MKPlacemark(placemark: placemarkMade);
        
        let mapItem = MKMapItem(placemark: place)
        
        let options = [MKLaunchOptionsDirectionsModeKey:
        MKLaunchOptionsDirectionsModeDriving]
        
        mapItem.openInMapsWithLaunchOptions(options)
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
