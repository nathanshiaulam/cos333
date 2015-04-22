//
//  SetCuisineViewController.swift
//  Noms
//
//  Created by Nathan Lam on 4/21/15.
//  Copyright (c) 2015 COS333. All rights reserved.
//

import UIKit

class SetCuisineViewController: UIViewController{
    
    var pickerData = ["Chinese", "Indian", "Mexican", "American", "Coffee & Tea", "Thai", "Greek", "Japanese", "French", "Italian", "German", "Mediterranean", "Vietnamese", "Bubble Tea", "Korean", "African", "Spanish", "Brazillian", "Cupcakes", "Filipino", "Greek", "Seafood", "Steakhouses", "Breweries", "Malaysian", "Bakeries", "Dessert"];
    @IBOutlet weak var cuisinePickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
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
        return myTitle;
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
