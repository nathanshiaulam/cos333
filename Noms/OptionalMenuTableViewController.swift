//
//  OptionalMenuTableViewController.swift
//  Noms
//
//  Created by Annie Chu on 5/1/15.
//  Copyright (c) 2015 COS333. All rights reserved.
//

import UIKit
import Parse

class OptionalMenuTableViewController: UITableViewController {
    
    override func viewWillDisappear(animated: Bool) {
        var defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults();
        
        var ambi = [String]();
        if (loveSwitch.on) {
            ambi.append("Romantic");
        }
        if (casualSwitch.on) {
            ambi.append("Casual");
        }
        if (classySwitch.on) {
            ambi.append("Classy");
        }
        
        var options = "";
        if (reserveSwitch.selectedSegmentIndex == 0) {
            options = options + "1"
        }
        else if (reserveSwitch.selectedSegmentIndex == 1) {
            options = options + "2"
        }
        else {
            options = options + "0"
        }
        if (takeoutSwitch.selectedSegmentIndex == 0) {
            options = options + "1"
        }
        else if (takeoutSwitch.selectedSegmentIndex == 1) {
            options = options + "2"
        }
        else {
            options = options + "0"
        }
        if (creditSwitch.selectedSegmentIndex == 0) {
            options = options + "1"
        }
        else if (creditSwitch.selectedSegmentIndex == 1) {
            options = options + "2"
        }
        else {
            options = options + "0"
        }
        if (alcSwitch.selectedSegmentIndex == 0) {
            options = options + "1"
        }
        else if (alcSwitch.selectedSegmentIndex == 1) {
            options = options + "2"
        }
        else {
            options = options + "0"
        }
        if (outSwitch.selectedSegmentIndex == 0) {
            options = options + "1"
        }
        else if (outSwitch.selectedSegmentIndex == 1) {
            options = options + "2"
        }
        else {
            options = options + "0"
        }
        if (wifiSwitch.selectedSegmentIndex == 0) {
            options = options + "1"
        }
        else if (wifiSwitch.selectedSegmentIndex == 1) {
            options = options + "2"
        }
        else {
            options = options + "0"
        }
        defaults.setObject(ambi, forKey:"Ambience");
        defaults.setObject(options, forKey:"Options");
        var currentProfileName = defaults.objectForKey("Name") as! String;
        var query = PFQuery(className:"Preferences");
        var currentID = PFUser.currentUser()!.objectId;
        query.whereKey("ID", equalTo:currentID!);
        query.whereKey("Name", equalTo:currentProfileName);
        query.getFirstObjectInBackgroundWithBlock {
            (preference: PFObject?, error: NSError?) -> Void in
            if error != nil || preference == nil {
                println(error);
            } else if let preference = preference{
                preference["Options"] = options;
                preference["Ambience"] = ambi;
                preference.saveInBackground();
            }
        }
        super.viewWillDisappear(true);
    }
    
    //outlets for the GUI elements
    @IBOutlet weak var reserveSwitch: UISegmentedControl!
    @IBOutlet weak var takeoutSwitch: UISegmentedControl!
    @IBOutlet weak var wifiSwitch: UISegmentedControl!
    @IBOutlet weak var outSwitch: UISegmentedControl!
    @IBOutlet weak var alcSwitch: UISegmentedControl!
    @IBOutlet weak var creditSwitch: UISegmentedControl!
    @IBOutlet weak var loveSwitch: UISwitch!
    @IBOutlet weak var classySwitch: UISwitch!
    
    
    @IBOutlet weak var casualSwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //load the preferences from Parse and update the GUI elements accordingly
        var defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults();
        var currentProfileName = defaults.objectForKey("Name") as! String;
        var query = PFQuery(className:"Preferences");
        var currentID = PFUser.currentUser()!.objectId;
        query.whereKey("ID", equalTo:currentID!);
        query.whereKey("Name", equalTo:currentProfileName);
        query.getFirstObjectInBackgroundWithBlock {
            (preference: PFObject?, error: NSError?) -> Void in
            if error != nil || preference == nil {
                println(error);
            } else if let preference = preference{

                let options = Array(preference["Options"] as! String);
                if (options[0] == "2") {
                    self.reserveSwitch.selectedSegmentIndex = 1;
                }
                if (options[1] == "2") {
                    self.takeoutSwitch.selectedSegmentIndex = 1;
                }
                if (options[2] == "2") {
                    self.creditSwitch.selectedSegmentIndex = 1;
                }
                if (options[3] == "2") {
                    self.alcSwitch.selectedSegmentIndex = 1;
                }
                if (options[4] == "2") {
                    self.outSwitch.selectedSegmentIndex = 1;
                }
                if (options[5] == "2") {
                    self.wifiSwitch.selectedSegmentIndex = 1;
                }
                let am = preference["Ambience"] as! [String];
                
                if (find(am, "Romantic") == nil) {
                    self.loveSwitch.on = false;
                }
                if (find(am, "Classy") == nil) {
                    self.classySwitch.on = false;
                }
                if (find(am, "Casual") == nil) {
                    self.casualSwitch.on = false;
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return 9
    }


}
