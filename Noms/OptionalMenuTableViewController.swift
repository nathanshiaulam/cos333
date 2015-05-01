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

    @IBAction func saveButton(sender: UIButton) {
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
        println(options + " options\n");
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
                println(ambi);
                preference["Ambience"] = ambi;
                preference.saveInBackground();
            }
        }
        
        
    }
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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 9
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
