//
//  NameProfileViewController.swift
//  Noms
//
//  Created by Nathan Lam on 4/16/15.
//  Copyright (c) 2015 COS333. All rights reserved.
//

import UIKit

class NameProfileViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldShouldReturn(textField: UITextField)-> Bool {
        textField.resignFirstResponder();
        self.performSegueWithIdentifier("toNewProfileSettings", sender: self);
        return true;
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
