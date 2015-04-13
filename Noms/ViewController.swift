//
//  ViewController.swift
//  Noms
//
//  Created by Nathan Lam on 4/12/15.
//  Copyright (c) 2015 COS333. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {
    func userLoggedIn() -> Bool{
        var currentUser = PFUser.currentUser();
        if ((currentUser) != nil) {
            return true;
        }
        return false;
        
    }
    func userLogOut() {
        PFUser.logOut();
        self.performSegueWithIdentifier("toUserLogin", sender: self);
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if (!self.userLoggedIn()) {
            self.performSegueWithIdentifier("toUserLogin", sender: self);
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
