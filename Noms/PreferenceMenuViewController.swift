//
//  PreferenceMenuViewController.swift
//  Noms
//
//  Created by Nathan Lam on 4/14/15.
//  Copyright (c) 2015 COS333. All rights reserved.
//

import UIKit
import Parse

class PreferenceMenuViewController: UIViewController {
    // PROFILE NAME LABEL
    @IBOutlet weak var profileName: UILabel!
    
    // CASH BUTTONS
    @IBOutlet weak var oneDollarSignButton: UIButton!
    @IBOutlet weak var twoDollarSignButton: UIButton!
    @IBOutlet weak var threeDollarSignButton: UIButton!
    
    // DISTANCE SLIDER OUTLETS
    @IBOutlet weak var distanceTextField: UILabel!
    @IBOutlet weak var distanceSlider: UISlider!
    
    // CUISINE PICKER
    @IBOutlet weak var cuisinePickerView: UIPickerView!
    
    // DECLARE VARIABLES
    var fromNew:Bool!;
    var currentProfileName:String!;
    var price:Int!;
    var distance:Int!;
    var cuisine:[String]!;
    
    // OPTIONAL FIELDS
    var ambience:[String]!;
    var options:String!;
//    var creditCards:Int!;
//    var outdoorSeating:Int!;
//    var reservations:Int!;
//    var takeOut:Int!;
//    var wifi:Int!;
//    var alcohol:Int!;
    
    // VAR PICKER DATA
    var pickerData = ["Chinese", "Indian", "Mexican", "American", "Coffee & Tea", "Thai", "Greek", "Japanese", "French", "Italian", "German", "Mediterranean", "Vietnamese", "Bubble Tea", "Korean", "African", "Spanish", "Brazillian", "Cupcakes", "Filipino", "Greek", "Seafood", "Steakhouses", "Breweries", "Malaysian", "Bakeries", "Dessert"];
    
    // DOLLAR SIGN CHANGE
    @IBAction func onClickOneDollar(sender: UIButton) {
        if (oneDollarSignButton.selected == true && twoDollarSignButton.selected == false && threeDollarSignButton.selected == false) {
            oneDollarSignButton.selected = true;
            price = 1;
        }
        else if (oneDollarSignButton.selected == true && twoDollarSignButton.selected == true && threeDollarSignButton.selected == false) {
            oneDollarSignButton.selected = true;
            twoDollarSignButton.selected = false;
            price = 1;
        }
        else if (oneDollarSignButton.selected == true && twoDollarSignButton.selected == true && threeDollarSignButton.selected == true) {
            oneDollarSignButton.selected = true;
            twoDollarSignButton.selected = false;
            threeDollarSignButton.selected = false;
            price = 1;
        }
        else {
            oneDollarSignButton.selected = true;
            price = 1;
        }
    }
    @IBAction func onClickTwoDollar(sender: UIButton) {
        if (oneDollarSignButton.selected == true && twoDollarSignButton.selected == true && threeDollarSignButton.selected == false) {
            oneDollarSignButton.selected = true;
            twoDollarSignButton.selected = false;
            price = 1;
        }
        else if (oneDollarSignButton.selected == true && twoDollarSignButton.selected == true && threeDollarSignButton.selected == true) {
            oneDollarSignButton.selected = true;
            twoDollarSignButton.selected = true;
            threeDollarSignButton.selected = false;
            price = 2;
            
        }
        else {
            oneDollarSignButton.selected = true;
            twoDollarSignButton.selected = true;
            price = 2;
        }
    }
    @IBAction func onClickThreeDollar(sender: UIButton) {
        if (oneDollarSignButton.selected == true && twoDollarSignButton.selected == true && threeDollarSignButton.selected == true) {
            oneDollarSignButton.selected = true;
            twoDollarSignButton.selected = false;
            threeDollarSignButton.selected = false;
            price = 1;
        }
        else {
            oneDollarSignButton.selected = true;
            twoDollarSignButton.selected = true;
            threeDollarSignButton.selected = true;
            price = 3;
        }
    }
    
    // ON SLIDER CHANGE
    @IBAction func sliderValueChanged(sender: UISlider) {
        var floatDistance = ceil(sender.value * 50);
        self.distanceTextField.text = NSString(format:"%.0f", floatDistance) as String + " miles";
        distance = Int(floatDistance);
    }
    
    // FUNCTIONS FOR PICKER 
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1;
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count;
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return pickerData[row];
    }
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = pickerData[row];
        var myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 15.0)!,NSForegroundColorAttributeName:UIColor.whiteColor()]);
        var stringArray = [myTitle.string];
        cuisine = stringArray;
        return myTitle;
    }
    
    // SAVE ITEM
    @IBAction func onClickSaveButton(sender: UIButton) {
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(currentProfileName, forKey: "Name")
        NSNotificationCenter.defaultCenter().postNotificationName("updateProfilePage", object: nil);


        if (fromNew == true) {
            
            // CREATES NEW PROFILE
            var newProfile = PFObject(className:"Preferences");
            newProfile["ID"] = PFUser.currentUser()!.objectId;
            newProfile["Name"] = currentProfileName
            newProfile["Cuisine"] = cuisine;
            newProfile["Cost"] = price;
            newProfile["Distance"] = distance;
            newProfile["Ambience"] = ambience;
            newProfile["Options"] = options;
//            newProfile["CreditCards"] = creditCards;
//            newProfile["OutdoorSeating"] = outdoorSeating;
//            newProfile["Reservations"] = reservations;
//            newProfile["TakeOut"] = takeOut;
//            newProfile["Wifi"] = wifi;
//            newProfile["Alcohol"] = alcohol;
            
            // SAVES NEW PROFILE
            newProfile.saveInBackgroundWithBlock {
                (success:Bool, error:NSError?) -> Void in
                if (success) {
                    self.navigationController?.popToRootViewControllerAnimated(true);
                } else {
                    let errorString = error!.userInfo!["error"] as! NSString;
                    var alert = UIAlertController(title: "Submission Failure", message: errorString as String, preferredStyle: UIAlertControllerStyle.Alert);
                    alert.addAction(UIAlertAction(title:"Ok", style: UIAlertActionStyle.Default, handler: nil));
                    self.presentViewController(alert, animated: true, completion: nil);
                }
            }
        }
        else {
            var query = PFQuery(className:"Preferences");
            var currentID = PFUser.currentUser()!.objectId;
            query.whereKey("ID", equalTo:currentID!);
            query.whereKey("Name", equalTo:currentProfileName);

            query.getFirstObjectInBackgroundWithBlock {
                (preference: PFObject?, error: NSError?) -> Void in
                if error != nil || preference == nil {
                    println(error);
                } else if let preference = preference{
                    preference["Cuisine"] = self.cuisine;
                    preference["Cost"] = self.price;
                    preference["Distance"] = self.distance;
                    preference["Ambience"] = self.ambience;
                    preference["Options"] = self.options;
//                    preference["CreditCards"] = self.creditCards;
//                    preference["OutdoorSeating"] = self.outdoorSeating;
//                    preference["Reservations"] = self.reservations;
//                    preference["TakeOut"] = self.takeOut;
//                    preference["Wifi"] = self.wifi;
//                    preference["Alcohol"] = self.alcohol;
                    preference.saveInBackground();
                    self.navigationController?.popToRootViewControllerAnimated(true);
                }
            }
            
        
        }
    }
    

    override func viewDidLoad() {
        profileName.text = currentProfileName;
        oneDollarSignButton.setTitleColor(UIColor.yellowColor(), forState: UIControlState.Selected);
        twoDollarSignButton.setTitleColor(UIColor.yellowColor(), forState: UIControlState.Selected);
        threeDollarSignButton.setTitleColor(UIColor.yellowColor(), forState: UIControlState.Selected);
        
        
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

