//
//  SetPriceViewController.swift
//  Noms
//
//  Created by Nathan Lam on 4/20/15.
//  Copyright (c) 2015 COS333. All rights reserved.
//

import UIKit





class SetPriceViewController: UIViewController {
    var price:Int!;
    
    @IBOutlet weak var oneDollarSignButton: UIButton!
    @IBOutlet weak var twoDollarSignButton: UIButton!
    @IBOutlet weak var threeDollarSignButton: UIButton!
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
    @IBAction func onClickSavePrice(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        oneDollarSignButton.setTitleColor(UIColor.yellowColor(), forState: UIControlState.Selected);
        twoDollarSignButton.setTitleColor(UIColor.yellowColor(), forState: UIControlState.Selected);
        threeDollarSignButton.setTitleColor(UIColor.yellowColor(), forState: UIControlState.Selected);

        
        

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
