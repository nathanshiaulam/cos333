//
//  SetDistanceViewController.swift
//  Noms
//
//  Created by Nathan Lam on 4/20/15.
//  Copyright (c) 2015 COS333. All rights reserved.
//

import UIKit

class SetDistanceViewController: UIViewController {
    
    var distance:Float!;
    @IBAction func saveButton(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true);
    }
    @IBOutlet weak var distanceSlider: UISlider!
    @IBOutlet weak var distanceTextField: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func sliderValueChanged(sender: UISlider) {
        distance = ceil(sender.value * 50);
        self.distanceTextField.text = NSString(format:"%.0f", distance) as String + " miles";
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "preferenceToPrice") {
            let VC = segue.destinationViewController as! PreferenceMenuViewController;
            VC.distance = Int(distance);
            
        }
        
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
