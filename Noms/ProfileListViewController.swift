//
//  ProfileListViewController.swift
//  Noms
//  Displays the list of profiles available to a user.
//
//  Created by Annie Chu, Clement Lee, Evelyn Ding, Nathan Lam, and Sean Pan.
//  Copyright (c) 2015 COS333. All rights reserved.
//

import UIKit
import Parse
import Bolts

class ProfileListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    

    @IBOutlet weak var profileList: UITableView!
    
    var items: [String] = ["Temp"]
    func handleTap(recognizer: UITapGestureRecognizer) {
        var defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject("true", forKey:"updated");
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    override func viewDidLoad() {

        super.viewDidLoad()
        let test = UITapGestureRecognizer(target: self, action: "handleCancel:");
        test.cancelsTouchesInView = false;
        self.view.addGestureRecognizer(test);
        
        self.profileList.delegate = self;
        //self.profileList.allowsSelectionDuringEditing = true;
        self.profileList.dataSource = self;
        
        self.profileList.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.items = []; //load the things here
        
        //loads the profile names
        var query = PFQuery(className:"Preferences");
        var currentID = PFUser.currentUser()!.objectId;
        query.whereKey("ID", equalTo:currentID!);
        var objects = query.findObjects();
        if (objects != nil) {
           for object in objects! {
                self.items.append(object["Name"]! as! String);
            }
        
        }
        
        //sets the currently selected profile
        var defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults();
        let index = find(items, defaults.objectForKey("Name")! as! String);
        if (index != nil) {
            let ip = NSIndexPath(forRow: index!, inSection: 0);
            self.profileList.selectRowAtIndexPath(ip, animated: true, scrollPosition: UITableViewScrollPosition.Middle);
        }
        else {
            let ip = NSIndexPath(forRow: 0, inSection: 0);
            self.profileList.selectRowAtIndexPath(ip, animated: true, scrollPosition: UITableViewScrollPosition.Middle);
        }
        

        // Do any additional setup after loading the view.
    }

    
    // in the case that no profile is selected but the modal is closed.
    func handleCancel(sender: UIGestureRecognizer) -> Void {

        if (!self.view.pointInside(sender.locationInView(self.profileList), withEvent: nil)) {
            var defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults();
            var index:NSIndexPath = self.profileList.indexPathForSelectedRow()!;
            defaults.setObject(self.items[index.row], forKey: "Name");
            self.dismissViewControllerAnimated(true, completion: {
                defaults.setObject("true", forKey:"updated");
                NSNotificationCenter.defaultCenter().postNotificationName("updateProfilePage", object: nil);
            });

        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(profileList: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }
    
    func tableView(profileList: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.profileList.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        
        cell.textLabel?.text = self.items[indexPath.row]
        
        return cell
    }
    
    func tableView(profileList: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //load the selected profile and exit the modal.
        var defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults();
        defaults.setObject(self.items[indexPath.row], forKey: "Name");
        // Return to ViewController with updated profile
        self.dismissViewControllerAnimated(true, completion: {
            defaults.setObject("true", forKey:"updated");
            NSNotificationCenter.defaultCenter().postNotificationName("updateProfilePage", object: nil);
        });
    }

}
