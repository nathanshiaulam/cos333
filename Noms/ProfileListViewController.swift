//
//  ProfileListViewController.swift
//  Noms
//
//  Created by Nathan Lam on 4/20/15.
//  Copyright (c) 2015 COS333. All rights reserved.
//

import UIKit
import Parse
import Bolts

class ProfileListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    

    @IBOutlet weak var profileList: UITableView!
    
    var items: [String] = ["Temp"]
    func handleTap(recognizer: UITapGestureRecognizer) {
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
        
        self.items = [];//["Temp", "Hi", "Lol", "kek"] //load the things here
        var query = PFQuery(className:"Preferences");
        var currentID = PFUser.currentUser()!.objectId;
        query.whereKey("ID", equalTo:currentID!);
        var objects = query.findObjects();
        if (objects != nil) {
           for object in objects! {
                self.items.append(object["Name"]! as! String);
            }
        
        }
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
    
    func handleCancel(sender: UIGestureRecognizer) -> Void {

        if (!self.view.pointInside(sender.locationInView(self.profileList), withEvent: nil)) {
            var defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults();
            var index:NSIndexPath = self.profileList.indexPathForSelectedRow()!;
            defaults.setObject(self.items[index.row], forKey: "Name");
            self.dismissViewControllerAnimated(true, completion: {
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
        println("Loading profile "+self.items[indexPath.row])
        var defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults();
        defaults.setObject(self.items[indexPath.row], forKey: "Name");
        //self.dismissViewControllerAnimated(true, completion: {});
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
