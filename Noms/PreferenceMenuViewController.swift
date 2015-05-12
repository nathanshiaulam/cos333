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
    @IBOutlet weak var fourDollarSignButton: UIButton!
    
    // DISTANCE SLIDER OUTLETS
    @IBOutlet weak var distanceTextField: UILabel!
    @IBOutlet weak var distanceSlider: UISlider!
    
    // CUISINE PICKER
//    @IBOutlet weak var cuisinePickerView: UIPickerView!
    
    @IBOutlet var tokenView: KSTokenView!
    let names: Array<String> = List.names()
    // DECLARE VARIABLES
    var fromNew:Bool!;
    var currentProfileName:String!;
    
    
    // VAR PICKER DATA
//    var pickerData = ["Chinese", "Indian", "Mexican", "American", "Coffee & Tea", "Thai", "Greek", "Japanese", "French", "Italian", "German", "Mediterranean", "Vietnamese", "Bubble Tea", "Korean", "African", "Spanish", "Brazillian", "Cupcakes", "Filipino", "Greek", "Seafood", "Steakhouses", "Breweries", "Malaysian", "Bakeries", "Dessert"];
    
    // DOLLAR SIGN CHANGE
    @IBAction func onClickOneDollar(sender: UIButton) {
        var defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(1, forKey:"Price");
        if (oneDollarSignButton.selected == true && twoDollarSignButton.selected == false && threeDollarSignButton.selected == false && fourDollarSignButton.selected == false) {
            defaults.setObject(1, forKey:"Price");
        }
        else if (oneDollarSignButton.selected == true && twoDollarSignButton.selected == true && threeDollarSignButton.selected == false && fourDollarSignButton.selected == false) {
            oneDollarSignButton.selected = true;
            twoDollarSignButton.selected = false;
            defaults.setObject(1, forKey:"Price");
        }
        else if (oneDollarSignButton.selected == true && twoDollarSignButton.selected == true && threeDollarSignButton.selected == true && fourDollarSignButton.selected == false) {
            oneDollarSignButton.selected = true;
            twoDollarSignButton.selected = false;
            threeDollarSignButton.selected = false;
            defaults.setObject(1, forKey:"Price");
        }
        else if (oneDollarSignButton.selected == true && twoDollarSignButton.selected == true && threeDollarSignButton.selected == true && fourDollarSignButton.selected == true) {
            oneDollarSignButton.selected = true;
            twoDollarSignButton.selected = false;
            threeDollarSignButton.selected = false;
            fourDollarSignButton.selected = false;
            defaults.setObject(1, forKey:"Price");
        }
    }
    @IBAction func onClickTwoDollar(sender: UIButton) {
        var defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults();
        
        if (oneDollarSignButton.selected == true && twoDollarSignButton.selected == true && threeDollarSignButton.selected == false && fourDollarSignButton.selected == false) {
            oneDollarSignButton.selected = true;
            twoDollarSignButton.selected = false;
            defaults.setObject(1, forKey:"Price");
        }
        else if (oneDollarSignButton.selected == true && twoDollarSignButton.selected == true && threeDollarSignButton.selected == true && fourDollarSignButton.selected == false) {
            oneDollarSignButton.selected = true;
            twoDollarSignButton.selected = true;
            threeDollarSignButton.selected = false;
            defaults.setObject(2, forKey:"Price");
            
        }
        else if (oneDollarSignButton.selected == true && twoDollarSignButton.selected == true && threeDollarSignButton.selected == true && fourDollarSignButton.selected == true) {
            threeDollarSignButton.selected = false;
            fourDollarSignButton.selected = false;
            defaults.setObject(2, forKey:"Price");
        }
        else {
            oneDollarSignButton.selected = true;
            twoDollarSignButton.selected = true;
            defaults.setObject(2, forKey:"Price");
        }
    }
    @IBAction func onClickThreeDollar(sender: UIButton) {
        var defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if (oneDollarSignButton.selected == true && twoDollarSignButton.selected == true && threeDollarSignButton.selected == true
            && fourDollarSignButton.selected == false) {
            threeDollarSignButton.selected = false;
            defaults.setObject(2, forKey:"Price");
        }
        else if (oneDollarSignButton.selected == true && twoDollarSignButton.selected == true && threeDollarSignButton.selected == true && fourDollarSignButton.selected == true) {
                fourDollarSignButton.selected = false;
                defaults.setObject(2, forKey:"Price");
        }
        else {
            oneDollarSignButton.selected = true;
            twoDollarSignButton.selected = true;
            threeDollarSignButton.selected = true;
            defaults.setObject(3, forKey:"Price");
        }
    }
    
    @IBAction func onClickFourDollar(sender: UIButton) {
        var defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if (oneDollarSignButton.selected == true && twoDollarSignButton.selected == true && threeDollarSignButton.selected == true && fourDollarSignButton.selected == true) {
            oneDollarSignButton.selected = true;
            twoDollarSignButton.selected = true;
            threeDollarSignButton.selected = true;
            fourDollarSignButton.selected = false;
            defaults.setObject(3, forKey:"Price");
        }
        else {
            oneDollarSignButton.selected = true;
            twoDollarSignButton.selected = true;
            threeDollarSignButton.selected = true;
            fourDollarSignButton.selected = true;
            defaults.setObject(4, forKey:"Price");
        }

    }
    
    // ON SLIDER CHANGE
    @IBAction func sliderValueChanged(sender: UISlider) {
        var floatDistance = floor(sender.value);
        var defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        self.distanceTextField.text = NSString(format:"%.0f", floatDistance) as String + " miles";
        defaults.setObject(Int(floatDistance), forKey:"Distance");
    }
    
//    // FUNCTIONS FOR PICKER 
//    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
//        return 1;
//    }
//    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return pickerData.count;
//    }
//    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
//        return pickerData[row];
//    }
//    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
//        let titleData = pickerData[row];
//        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
//        var myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 15.0)!,NSForegroundColorAttributeName:UIColor.whiteColor()]);
//        var stringArray = [myTitle.string];
//        defaults.setObject(stringArray, forKey:"Cuisine");
//        return myTitle;
//    }
    
    // SAVE ITEM
    @IBAction func onClickSaveButton(sender: UIButton) {
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        currentProfileName = defaults.objectForKey("Name") as! String;
        NSLog(currentProfileName);
        defaults.setObject(currentProfileName, forKey: "Name")
        defaults.setObject("true", forKey:"updated");
        NSNotificationCenter.defaultCenter().postNotificationName("updateProfilePage", object: nil);
        
        // Sets the text from the tokens
        var tokens: Array<KSToken> = tokenView.tokens()!;
        var cuisineArray:[String] = [];
        for (var i = 0; i < count(tokens); i++) {
            cuisineArray.append(tokens[i].description2());
        }
        if (count(cuisineArray) == 0) {
            let errorString = "You haven't entered any cuisine choices!";
            var alert = UIAlertController(title: "Enter a cuisine:", message: errorString as String, preferredStyle: UIAlertControllerStyle.Alert);
            alert.addAction(UIAlertAction(title:"Ok", style: UIAlertActionStyle.Default, handler: nil));
            self.presentViewController(alert, animated: true, completion: nil);
        }
        defaults.setObject(cuisineArray, forKey:"Cuisine");
        
        if (fromNew == true) {
            
            // CREATES NEW PROFILE
            var newProfile = PFObject(className:"Preferences");
            newProfile["ID"] = PFUser.currentUser()!.objectId;
            newProfile["Name"] = currentProfileName
            newProfile["Cuisine"] =  defaults.objectForKey("Cuisine") as! [String];
            newProfile["Cost"] = defaults.objectForKey("Price") as! Int;
            newProfile["Distance"] = defaults.objectForKey("Distance") as! Int;
            newProfile["Ambience"] = defaults.objectForKey("Ambience") as! [String];
            newProfile["Options"] = defaults.objectForKey("Options") as! String;
            newProfile["Weights"] = [1,1,1,1.5];
            
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
                    preference["Cuisine"] = defaults.objectForKey("Cuisine") as! [String];
                    preference["Cost"] = defaults.objectForKey("Price") as! Int;
                    preference["Distance"] = defaults.objectForKey("Distance") as! Int;
                    preference["Ambience"] = defaults.objectForKey("Ambience") as! [String];
                    preference["Options"] = defaults.objectForKey("Options") as! String;
                    preference.saveInBackground();
                    self.navigationController?.popToRootViewControllerAnimated(true);
                }
            }
            
        
        }
    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true);
        
    }
    

    //sets current preferences from the profile
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        
        var defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults();
        tokenView.delegate = self
        tokenView.promptText = ""
        tokenView.placeholder = "Type to search"
        tokenView.descriptionText = "Cuisines"
        tokenView.maxTokenLimit = 5
        tokenView.style = .Rounded
        tokenView.searchResultSize.height = 100;
        //tokenView.searchResultBackgroundColor = UIColor.lightGrayColor();
        
        profileName.text = defaults.objectForKey("Name") as! String!;
        oneDollarSignButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Selected);
        twoDollarSignButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Selected);
        threeDollarSignButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Selected);
        fourDollarSignButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Selected);
        
        var amount = defaults.objectForKey("Price") as! Int;
        var distance = defaults.objectForKey("Distance") as! Int;
        var cuisine = defaults.objectForKey("Cuisine") as! [String];
        if (fromNew == false) {
            for (var i = 0; i < count(cuisine); i++) {
                tokenView.addTokenWithTitle(cuisine[i]);
            }
        }
        
        // SETS PRICE
        if amount == 1 {
            oneDollarSignButton.selected = true;
        } else if amount == 2 {
            oneDollarSignButton.selected = true;
            twoDollarSignButton.selected = true;
        } else if amount == 3 {
            oneDollarSignButton.selected = true;
            twoDollarSignButton.selected = true;
            threeDollarSignButton.selected = true;
        } else {
            oneDollarSignButton.selected = true;
            twoDollarSignButton.selected = true;
            threeDollarSignButton.selected = true;
            fourDollarSignButton.selected = true;
        }
        
        // SETS DISTANCE VALUE
        distanceTextField.text = NSString(format:"%.0f", Float(distance)) as String + " miles";
        distanceSlider.setValue(Float(distance), animated: true);
        
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func keyboardWillShow (sender: NSNotification) {
        self.view.frame.origin.y -= 75
    }
    func keyboardWillHide (sender: NSNotification) {
        self.view.frame.origin.y += 75
    }
}

extension PreferenceMenuViewController: KSTokenViewDelegate {
    func tokenView(token: KSTokenView, performSearchWithString string: String, completion: ((results: Array<AnyObject>) -> Void)?) {
        var data: Array<String> = []
        for value: String in List.names() {
            if value.lowercaseString.rangeOfString(string.lowercaseString) != nil {
                data.append(value)
            }
        }
        completion!(results: data)
    }
    
    func tokenView(token: KSTokenView, displayTitleForObject object: AnyObject) -> String {
        return object as! String
    }
}
